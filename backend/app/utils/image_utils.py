import os
import uuid
from pathlib import Path
from PIL import Image

from app.config import get_settings

settings = get_settings()


def ensure_directories():
    """Create storage directories if they don't exist."""
    base = Path(__file__).resolve().parent.parent.parent
    dirs = [
        base / settings.uploads_dir,
        base / settings.results_dir,
        base / settings.crops_dir,
        base / settings.flowers_dir,
    ]
    for d in dirs:
        d.mkdir(parents=True, exist_ok=True)


def get_base_path() -> Path:
    return Path(__file__).resolve().parent.parent.parent


def save_upload(file_content: bytes, filename: str | None = None) -> str:
    """Save uploaded image to uploads/ and return relative path."""
    ensure_directories()
    base = get_base_path()
    ext = Path(filename).suffix if filename else ".jpg"
    unique_name = f"{uuid.uuid4()}{ext}"
    path = base / settings.uploads_dir / unique_name
    with open(path, "wb") as f:
        f.write(file_content)
    return f"{settings.uploads_dir}/{unique_name}"


def save_result_image(image: Image.Image, detection_id: int) -> str:
    """Save result image with bounding boxes to results/."""
    ensure_directories()
    base = get_base_path()
    path = base / settings.results_dir / f"result_{detection_id}.jpg"
    image.save(path)
    return f"{settings.results_dir}/result_{detection_id}.jpg"


def save_crop(image: Image.Image, detection_id: int, index: int) -> str:
    """Save cropped flower to crops/."""
    ensure_directories()
    base = get_base_path()
    path = base / settings.crops_dir / f"det_{detection_id}_{index}.jpg"
    image.save(path)
    return f"{settings.crops_dir}/det_{detection_id}_{index}.jpg"


def path_to_url(path: str, base_url: str = "http://localhost:8000") -> str:
    """Convert storage path to URL for API response."""
    if not path:
        return ""
    normalized = path.replace("\\", "/")
    return f"{base_url.rstrip('/')}/{normalized}"
