from fastapi import APIRouter, Depends, HTTPException, Request, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func

from app.database import get_db
from app.models.device import Device
from app.models.flower import Flower
from app.models.detection import Detection, DetectionResult
from app.schemas.detection import (
    DetectionListItemResponse,
    DetectionDetailResponse,
    DetectionDetailItemResponse,
    DeleteResponse,
)
from app.utils.image_utils import path_to_url

router = APIRouter(prefix="/detections", tags=["Detections"])


def get_base_url(request: Request) -> str:
    return str(request.base_url).rstrip("/")


@router.get("", response_model=list[DetectionListItemResponse])
async def get_detections(
    request: Request,
    device_id: str = Query(..., description="Device UUID"),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Device).where(Device.device_id == device_id)
    )
    device = result.scalar_one_or_none()
    if device is None:
        return []

    det_result = await db.execute(
        select(Detection)
        .where(Detection.device_id == device.id)
        .order_by(Detection.created_at.desc())
    )
    detections = det_result.scalars().all()

    base_url = get_base_url(request)
    items = []
    for d in detections:
        count_result = await db.execute(
            select(func.count(DetectionResult.id)).where(DetectionResult.detection_id == d.id)
        )
        count = count_result.scalar() or 0
        items.append(
            DetectionListItemResponse(
                id=d.id,
                image_url=path_to_url(d.image_path, base_url),
                result_image_url=path_to_url(d.result_image_path or "", base_url),
                detections_count=count,
                created_at=d.created_at,
            )
        )
    return items


@router.get("/{detection_id}", response_model=DetectionDetailResponse)
async def get_detection(
    request: Request,
    detection_id: int,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Detection).where(Detection.id == detection_id)
    )
    detection = result.scalar_one_or_none()
    if detection is None:
        raise HTTPException(status_code=404, detail="Detection not found")

    res_result = await db.execute(
        select(DetectionResult, Flower)
        .join(Flower, DetectionResult.flower_id == Flower.id)
        .where(DetectionResult.detection_id == detection_id)
    )
    rows = res_result.all()

    base_url = get_base_url(request)
    det_items = [
        DetectionDetailItemResponse(
            class_name=flower.name,
            confidence=dr.confidence,
            crop_url=path_to_url(dr.crop_path, base_url) if dr.crop_path else None,
        )
        for dr, flower in rows
    ]

    return DetectionDetailResponse(
        id=detection.id,
        image_url=path_to_url(detection.image_path, base_url),
        result_image_url=path_to_url(detection.result_image_path or "", base_url),
        detections=det_items,
    )


@router.delete("/{detection_id}", response_model=DeleteResponse)
async def delete_detection(
    detection_id: int,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Detection).where(Detection.id == detection_id)
    )
    detection = result.scalar_one_or_none()
    if detection is None:
        raise HTTPException(status_code=404, detail="Detection not found")

    await db.delete(detection)
    await db.commit()
    return DeleteResponse()
