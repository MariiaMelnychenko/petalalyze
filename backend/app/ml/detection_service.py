"""
Detection service for flower recognition.
Uses mock model for now - replace with actual YOLO when ready.
Class IDs 1-23 correspond to flowers in DB (alstroemeria, anthurium, ...).
"""
from dataclasses import dataclass
from PIL import Image
import random


@dataclass
class DetectionItem:
    bbox: tuple[float, float, float, float]  # x, y, width, height
    class_id: int
    class_name: str
    confidence: float
    crop: Image.Image | None = None


# Flower classes matching DB seed order (IDs 1-23)
MOCK_FLOWER_CLASSES = [
    {"id": 1, "name": "Альстремерія", "latin": "Alstroemeria"},
    {"id": 2, "name": "Антуріум", "latin": "Anthurium"},
    {"id": 3, "name": "Гвоздика садова", "latin": "Carnation"},
    {"id": 4, "name": "Хризантема", "latin": "Chrysanthemum"},
    {"id": 5, "name": "Нарцис", "latin": "Daffodil"},
    {"id": 6, "name": "Георгина", "latin": "Dahlia"},
    {"id": 7, "name": "Гвоздика", "latin": "Dianthus"},
    {"id": 8, "name": "Плюмерія", "latin": "Frangipani"},
    {"id": 9, "name": "Гербера", "latin": "Gerbera"},
    {"id": 10, "name": "Гладиолус", "latin": "Gladiolus"},
    {"id": 11, "name": "Гіпеаструм", "latin": "Hippeastrum"},
    {"id": 12, "name": "Гортензія", "latin": "Hydrangea"},
    {"id": 13, "name": "Ірис", "latin": "Iris"},
    {"id": 14, "name": "Протея королівська", "latin": "King Protea"},
    {"id": 15, "name": "Лотос", "latin": "Lotus"},
    {"id": 16, "name": "Орхідея місячна", "latin": "Moon Orchid"},
    {"id": 17, "name": "Нівяник", "latin": "Oxeye Daisy"},
    {"id": 18, "name": "Півонія", "latin": "Paeonia"},
    {"id": 19, "name": "Георгина рожево-жовта", "latin": "Pink Yellow Dahlia"},
    {"id": 20, "name": "Троянда", "latin": "Rose"},
    {"id": 21, "name": "Соняшник", "latin": "Sunflower"},
    {"id": 22, "name": "Тюльпан", "latin": "Tulip"},
    {"id": 23, "name": "Калла", "latin": "Zantedeschia"},
]


class DetectionService:
    """Service for running flower detection on images."""

    def __init__(self):
        self.classes = MOCK_FLOWER_CLASSES

    async def detect(self, image: Image.Image) -> list[DetectionItem]:
        """
        Run detection on image.
        Mock: returns 1-3 random detections.
        Real: will use YOLO model.
        """
        width, height = image.size
        num_detections = random.randint(1, min(3, len(self.classes)))

        results = []
        used_classes = set()

        for i in range(num_detections):
            cls = random.choice([c for c in self.classes if c["id"] not in used_classes])
            used_classes.add(cls["id"])

            box_w = random.randint(int(width * 0.15), int(width * 0.4))
            box_h = random.randint(int(height * 0.15), int(height * 0.4))
            box_x = random.randint(0, max(0, width - box_w))
            box_y = random.randint(0, max(0, height - box_h))

            try:
                crop = image.crop((box_x, box_y, box_x + box_w, box_y + box_h))
            except Exception:
                crop = None

            confidence = round(random.uniform(0.7, 0.99), 2)
            results.append(
                DetectionItem(
                    bbox=(float(box_x), float(box_y), float(box_w), float(box_h)),
                    class_id=cls["id"],
                    class_name=cls["name"],
                    confidence=confidence,
                    crop=crop,
                )
            )

        return results


def get_detection_service() -> DetectionService:
    return DetectionService()
