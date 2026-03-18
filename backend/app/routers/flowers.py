from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database import get_db
from app.models.flower import Flower
from app.schemas.flower import FlowerResponse, FlowerDetailResponse

router = APIRouter(prefix="/flowers", tags=["Flowers"])


@router.get("", response_model=list[FlowerResponse])
async def get_flowers(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Flower).order_by(Flower.id))
    flowers = result.scalars().all()
    return flowers


@router.get("/{flower_id}", response_model=FlowerDetailResponse)
async def get_flower(flower_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Flower).where(Flower.id == flower_id))
    flower = result.scalar_one_or_none()
    if flower is None:
        raise HTTPException(status_code=404, detail="Flower not found")
    return flower
