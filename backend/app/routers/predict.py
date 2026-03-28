"""POST /predict — YOLO detection + ensemble classification + save to history."""

import io
import logging

from fastapi import APIRouter, Depends, File, Form, HTTPException, Request, UploadFile
from PIL import Image, ImageDraw, UnidentifiedImageError
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.detection import Detection, DetectionResult
from app.models.flower import Flower
from app.services.device_service import DeviceService
from app.services.inference_service import run_prediction
from app.utils.image_utils import path_to_url, save_crop, save_result_image, save_upload

logger = logging.getLogger(__name__)

router = APIRouter(tags=["Predict"])

# classifier class_name → (DB latin_name, display name for UI)
_CLASS_INFO: dict[str, tuple[str, str]] = {
    "alstroemeria_crops": ("Alstroemeria", "Альстремерія"),
    "anthurium_crops": ("Anthurium", "Антуріум"),
    "carnation_crops": ("Carnation", "Гвоздика"),
    "chrysanthemum_crops": ("Chrysanthemum", "Хризантема"),
    "daffodil_crops": ("Daffodil", "Нарцис"),
    "dahlia_crops": ("Dahlia", "Жоржина"),
    "frangipani_crops": ("Frangipani", "Плюмерія"),
    "gerbera_crops": ("Gerbera", "Гербера"),
    "gladiolus_crops": ("Gladiolus", "Гладіолус"),
    "hydrangea_crops": ("Hydrangea", "Гортензія"),
    "iris_crops": ("Iris", "Ірис"),
    "lily_crops": ("Lily", "Лілія"),
    "orchid_crops": ("Moon Orchid", "Орхідея"),
    "oxeye_daisy_crops": ("Oxeye Daisy", "Ромашка"),
    "paeonia_crops": ("Paeonia", "Півонія"),
    "rose_crops": ("Rose", "Троянда"),
    "sunflower_crops": ("Sunflower", "Соняшник"),
    "tulip_crops": ("Tulip", "Тюльпан"),
    "zantedeschia_crops": ("Zantedeschia", "Калла"),
}


class PredictionItemResponse(BaseModel):
    bbox: list[float]
    class_name: str
    confidence: float
    yolo_confidence: float
    ensemble_confidence: float
    crop_url: str | None = None


class PredictResponse(BaseModel):
    detection_id: int
    result_image_url: str
    predictions: list[PredictionItemResponse]


def _display_name(raw_class: str) -> str:
    info = _CLASS_INFO.get(raw_class)
    if info:
        return info[1]
    return raw_class.removesuffix("_crops").replace("_", " ").title()


def _draw_boxes(image: Image.Image, predictions, names: list[str]) -> Image.Image:
    img = image.copy()
    draw = ImageDraw.Draw(img)
    for p, name in zip(predictions, names):
        x1, y1, x2, y2 = p.bbox
        draw.rectangle([x1, y1, x2, y2], outline="green", width=3)
        label = f"{name} {p.confidence:.2f}"
        draw.text((int(x1), max(0, int(y1) - 15)), label, fill="green")
    return img


async def _build_flower_lookup(db: AsyncSession) -> dict[str, int]:
    """Build latin_name → flower_id lookup from the flowers table."""
    result = await db.execute(select(Flower.id, Flower.latin_name))
    return {latin.strip(): fid for fid, latin in result.all() if latin}


@router.post("/predict", response_model=PredictResponse)
async def predict(
    request: Request,
    file: UploadFile = File(...),
    device_id: str = Form(...),
    db: AsyncSession = Depends(get_db),
):
    if not device_id or len(device_id) < 10:
        raise HTTPException(status_code=400, detail="Invalid device_id")

    content = await file.read()
    if not content:
        raise HTTPException(status_code=400, detail="Uploaded file is empty.")

    try:
        image = Image.open(io.BytesIO(content)).convert("RGB")
    except (UnidentifiedImageError, Exception):
        raise HTTPException(status_code=400, detail="Cannot open the uploaded file as an image.")

    try:
        results = run_prediction(image)
    except Exception as exc:
        logger.exception("Prediction pipeline failed")
        raise HTTPException(status_code=500, detail=f"Prediction error: {exc}")

    device = await DeviceService.get_or_create(db, device_id)
    image_path = save_upload(content, file.filename)

    detection = Detection(device_id=device.id, image_path=image_path, result_image_path=None)
    db.add(detection)
    await db.flush()

    display_names = [_display_name(r.class_name) for r in results]

    result_img = _draw_boxes(image, results, display_names)
    result_image_path = save_result_image(result_img, detection.id)
    detection.result_image_path = result_image_path

    latin_to_id = await _build_flower_lookup(db)
    base_url = str(request.base_url).rstrip("/")

    response_items: list[PredictionItemResponse] = []
    for idx, r in enumerate(results):
        crop_path: str | None = None
        if r.crop is not None:
            crop_path = save_crop(r.crop, detection.id, idx)

        info = _CLASS_INFO.get(r.class_name)
        latin = info[0] if info else None
        flower_id = latin_to_id.get(latin) if latin else None

        if flower_id is not None:
            x1, y1, x2, y2 = r.bbox
            dr = DetectionResult(
                detection_id=detection.id,
                flower_id=flower_id,
                confidence=r.confidence,
                crop_path=crop_path,
                bbox_x=x1,
                bbox_y=y1,
                bbox_width=x2 - x1,
                bbox_height=y2 - y1,
            )
            db.add(dr)

        response_items.append(
            PredictionItemResponse(
                bbox=r.bbox,
                class_name=display_names[idx],
                confidence=r.confidence,
                yolo_confidence=r.yolo_confidence,
                ensemble_confidence=r.ensemble_confidence,
                crop_url=path_to_url(crop_path, base_url) if crop_path else None,
            )
        )

    await db.commit()
    await db.refresh(detection)

    return PredictResponse(
        detection_id=detection.id,
        result_image_url=path_to_url(result_image_path, base_url),
        predictions=response_items,
    )
