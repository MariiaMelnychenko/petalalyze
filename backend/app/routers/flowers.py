from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database import get_db
from app.models.flower import Flower
from app.schemas.flower import FlowerResponse, FlowerDetailResponse

router = APIRouter(prefix="/flowers", tags=["Flowers"])


def _abs_image_url(request: Request, raw: str | None) -> str | None:
    if not raw:
        return raw
    if raw.startswith(("http://", "https://")):
        return raw
    return str(request.base_url) + raw.lstrip("/")


@router.get("", response_model=list[FlowerResponse])
async def get_flowers(request: Request, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Flower).order_by(Flower.id))
    flowers = result.scalars().all()
    out = []
    for f in flowers:
        d = FlowerResponse.model_validate(f)
        d.image_url = _abs_image_url(request, d.image_url)
        out.append(d)
    return out


@router.get("/{flower_id}", response_model=FlowerDetailResponse)
async def get_flower(flower_id: int, request: Request, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Flower).where(Flower.id == flower_id))
    flower = result.scalar_one_or_none()
    if flower is None:
        raise HTTPException(status_code=404, detail="Flower not found")
    d = FlowerDetailResponse.model_validate(flower)
    d.image_url = _abs_image_url(request, d.image_url)
    return d
