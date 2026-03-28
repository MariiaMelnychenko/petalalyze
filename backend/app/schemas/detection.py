from datetime import datetime
from pydantic import BaseModel


class DetectionListItemResponse(BaseModel):
    id: int
    image_url: str
    result_image_url: str
    detections_count: int
    created_at: datetime

    class Config:
        from_attributes = True


class DetectionDetailItemResponse(BaseModel):
    class_name: str
    confidence: float
    crop_url: str | None


class DetectionDetailResponse(BaseModel):
    id: int
    image_url: str
    result_image_url: str
    detections: list[DetectionDetailItemResponse]

    class Config:
        from_attributes = True


class DeleteResponse(BaseModel):
    status: str = "deleted"
