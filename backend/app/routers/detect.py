from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, Request
from sqlalchemy.ext.asyncio import AsyncSession
from PIL import Image
import io

from app.database import get_db
from app.models.detection import Detection, DetectionResult
from app.schemas.detection import DetectResponse, DetectionItemInResponse
from app.services.device_service import DeviceService
from app.services.detection_service import draw_boxes_on_image
from app.ml.detection_service import get_detection_service
from app.utils.image_utils import save_upload, save_result_image, save_crop, path_to_url

router = APIRouter(tags=["Detect"])


@router.post("/detect", response_model=DetectResponse)
async def detect_flowers(
    request: Request,
    image: UploadFile = File(...),
    device_id: str = Form(...),
    db: AsyncSession = Depends(get_db),
):
    if not device_id or len(device_id) < 10:
        raise HTTPException(status_code=400, detail="Invalid device_id")

    device = await DeviceService.get_or_create(db, device_id)

    content = await image.read()
    if not content:
        raise HTTPException(status_code=400, detail="Empty image")

    try:
        pil_image = Image.open(io.BytesIO(content)).convert("RGB")
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid image file")

    detection_svc = get_detection_service()
    detections = await detection_svc.detect(pil_image)

    image_path = save_upload(content, image.filename)

    result_image = draw_boxes_on_image(image_path, detections)

    detection = Detection(
        device_id=device.id,
        image_path=image_path,
        result_image_path=None,
    )
    db.add(detection)
    await db.flush()

    result_image_path = save_result_image(result_image, detection.id)
    detection.result_image_path = result_image_path

    base_url = str(request.base_url).rstrip("/")

    response_items = []
    for idx, det in enumerate(detections):
        crop_path = None
        if det.crop:
            crop_path = save_crop(det.crop, detection.id, idx)

        dr = DetectionResult(
            detection_id=detection.id,
            flower_id=det.class_id,
            confidence=det.confidence,
            crop_path=crop_path,
            bbox_x=det.bbox[0],
            bbox_y=det.bbox[1],
            bbox_width=det.bbox[2],
            bbox_height=det.bbox[3],
        )
        db.add(dr)

        response_items.append(
            DetectionItemInResponse(
                flower_id=det.class_id,
                class_name=det.class_name,
                confidence=det.confidence,
                bbox=list(det.bbox),
                crop_url=path_to_url(crop_path, base_url) if crop_path else None,
            )
        )

    await db.commit()
    await db.refresh(detection)

    return DetectResponse(
        detection_id=detection.id,
        result_image_url=path_to_url(result_image_path, base_url),
        detections=response_items,
    )
