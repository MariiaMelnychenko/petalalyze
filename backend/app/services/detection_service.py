from pathlib import Path
from PIL import Image, ImageDraw

from app.ml.detection_service import DetectionService, DetectionItem
from app.utils.image_utils import save_result_image, save_crop, get_base_path
from app.config import get_settings

settings = get_settings()


def draw_boxes_on_image(image_path: str, detections: list[DetectionItem]) -> Image.Image:
    """Draw bounding boxes on image and return PIL Image."""
    base = get_base_path()
    full_path = base / image_path
    img = Image.open(full_path).convert("RGB")
    draw = ImageDraw.Draw(img)

    for det in detections:
        x, y, w, h = det.bbox
        x1, y1 = int(x), int(y)
        x2, y2 = int(x + w), int(y + h)
        draw.rectangle([x1, y1, x2, y2], outline="green", width=3)
        label = f"{det.class_name} {det.confidence:.2f}"
        draw.text((x1, y1 - 15), label, fill="green")

    return img
