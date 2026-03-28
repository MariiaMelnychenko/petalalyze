"""
Inference pipeline: YOLO detection → padded crop → ensemble classification (soft voting).

Mirrors the logic from the Colab/Gradio prototype.
"""

import logging
from dataclasses import dataclass

import numpy as np
import torch
from PIL import Image

from app.services.model_loader import ModelStore, get_model_store

logger = logging.getLogger(__name__)


@dataclass
class PredictionResult:
    bbox: list[float]
    class_name: str
    confidence: float
    yolo_confidence: float
    ensemble_confidence: float
    crop: Image.Image | None = None


def _padded_crop(
    img_np: np.ndarray, x1: int, y1: int, x2: int, y2: int, pad_ratio: float = 0.3
) -> np.ndarray | None:
    """Crop with padding around the bounding box (same as Colab padded_crop)."""
    h, w = img_np.shape[:2]
    bw, bh = x2 - x1, y2 - y1
    pw, ph = int(bw * pad_ratio), int(bh * pad_ratio)

    cy1 = max(0, y1 - ph)
    cy2 = min(h, y2 + ph)
    cx1 = max(0, x1 - pw)
    cx2 = min(w, x2 + pw)

    if cy2 <= cy1 or cx2 <= cx1:
        return None

    crop = img_np[cy1:cy2, cx1:cx2]
    return crop if crop.size > 0 else None


def _classify_crop(
    pil_crop: Image.Image,
    store: ModelStore,
) -> tuple[str, float]:
    """
    Run all classifiers on a single crop and apply soft-voting ensemble.

    Returns (class_name, ensemble_confidence).
    """
    x = store.transform(pil_crop).unsqueeze(0).to(store.device)

    all_probs: list[np.ndarray] = []
    with torch.no_grad():
        for entry in store.classifiers.values():
            logits = entry.model(x)
            probs = torch.softmax(logits, dim=1)[0].cpu().numpy()
            all_probs.append(probs)

    prob_sum = np.zeros_like(all_probs[0])
    for p in all_probs:
        prob_sum += p

    idx = int(np.argmax(prob_sum))
    ensemble_confidence = float(np.max(prob_sum) / len(all_probs))

    first_entry = next(iter(store.classifiers.values()))
    class_name = first_entry.inv_label_map[idx]

    return class_name, ensemble_confidence


def run_prediction(
    image: Image.Image,
    *,
    yolo_conf: float = 0.05,
    pad_ratio: float = 0.3,
) -> list[PredictionResult]:
    """
    Full prediction pipeline.

    1. Run YOLO detector (low conf threshold to capture all candidates).
    2. For each bbox: padded crop → classify with ensemble.
    3. Combine YOLO confidence × ensemble confidence.
    """
    store = get_model_store()

    img_np = np.array(image)
    results = store.yolo.predict(img_np, conf=yolo_conf, imgsz=1024, verbose=False)

    if not results or len(results[0].boxes) == 0:
        return []

    predictions: list[PredictionResult] = []

    for box in results[0].boxes:
        x1, y1, x2, y2 = map(int, box.xyxy[0])
        yolo_confidence = float(box.conf[0])

        crop_np = _padded_crop(img_np, x1, y1, x2, y2, pad_ratio)
        if crop_np is None:
            continue

        pil_crop = Image.fromarray(crop_np)
        class_name, ensemble_confidence = _classify_crop(pil_crop, store)
        final_confidence = yolo_confidence * ensemble_confidence

        predictions.append(
            PredictionResult(
                bbox=[float(x1), float(y1), float(x2), float(y2)],
                class_name=class_name,
                confidence=round(final_confidence, 4),
                yolo_confidence=round(yolo_confidence, 4),
                ensemble_confidence=round(ensemble_confidence, 4),
                crop=pil_crop,
            )
        )

    return predictions
