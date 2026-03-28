"""
Singleton model loader — loads all ML models once at application startup.

Models (expected layout under backend/models/):
    detector.pt                          — YOLO flower/bouquet detector
    vit_base_patch16_224/
        best_model.pth
        label_map.json
    convnext_small/                      — + ViT-B16 (convnext_tiny вимкнено в CLASSIFIERS_CFG)
        best_model.pth
        label_map.json
"""

import json
import logging
from dataclasses import dataclass
from pathlib import Path

import timm
import torch
import torchvision.transforms as T
from ultralytics import YOLO

logger = logging.getLogger(__name__)

MODELS_DIR = Path(__file__).resolve().parent.parent.parent / "models"

IMG_SIZE = 224

CLASSIFIERS_CFG: dict[str, dict[str, str]] = {
    "ViT-B16": {
        "arch": "vit_base_patch16_224",
        "dir": "vit_base_patch16_224",
    },
    # "ConvNeXt-Tiny": {
    #     "arch": "convnext_tiny",
    #     "dir": "convnext_tiny",
    # },
    "ConvNeXt-Small": {
        "arch": "convnext_small",
        "dir": "convnext_small",
    },
}


@dataclass
class ClassifierEntry:
    """Single classifier with its model, inverse label map, and class count."""

    name: str
    model: torch.nn.Module
    inv_label_map: dict[int, str]
    num_classes: int


@dataclass
class ModelStore:
    """All loaded models + shared preprocessing."""

    yolo: YOLO
    classifiers: dict[str, ClassifierEntry]
    transform: T.Compose
    device: torch.device


_store: ModelStore | None = None


def _resolve_device() -> torch.device:
    if torch.cuda.is_available():
        return torch.device("cuda")
    return torch.device("cpu")


def _build_transform() -> T.Compose:
    return T.Compose([
        T.Resize(int(IMG_SIZE * 1.15)),
        T.CenterCrop(IMG_SIZE),
        T.ToTensor(),
        T.Normalize(mean=(0.485, 0.456, 0.406), std=(0.229, 0.224, 0.225)),
    ])


def _load_classifier(
    name: str, arch: str, model_dir: Path, device: torch.device
) -> ClassifierEntry:
    weights_path = model_dir / "best_model.pth"
    label_map_path = model_dir / "label_map.json"

    with open(label_map_path, encoding="utf-8") as f:
        label_map: dict[str, int] = json.load(f)

    inv_label_map = {int(v): k for k, v in label_map.items()}
    num_classes = len(label_map)

    model = timm.create_model(arch, pretrained=False, num_classes=num_classes)
    model.load_state_dict(
        torch.load(str(weights_path), map_location=device, weights_only=True)
    )
    model.to(device).eval()

    return ClassifierEntry(
        name=name,
        model=model,
        inv_label_map=inv_label_map,
        num_classes=num_classes,
    )


def load_models() -> ModelStore:
    """Load all models from disk. Called once at application startup."""
    global _store
    if _store is not None:
        return _store

    device = _resolve_device()
    logger.info("Using device: %s", device)

    yolo = YOLO(str(MODELS_DIR / "detector.pt"))
    logger.info("YOLO detector loaded")

    classifiers: dict[str, ClassifierEntry] = {}
    for name, cfg in CLASSIFIERS_CFG.items():
        model_dir = MODELS_DIR / cfg["dir"]
        entry = _load_classifier(name, cfg["arch"], model_dir, device)
        classifiers[name] = entry
        logger.info("Classifier '%s' loaded | classes=%d", name, entry.num_classes)

    transform = _build_transform()

    _store = ModelStore(
        yolo=yolo,
        classifiers=classifiers,
        transform=transform,
        device=device,
    )
    return _store


def get_model_store() -> ModelStore:
    """Return the pre-loaded model store. Raises if models not loaded yet."""
    if _store is None:
        raise RuntimeError("Models not loaded. Call load_models() during startup.")
    return _store
