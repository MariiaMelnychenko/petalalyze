"""
Скрипт для перезаповнення таблиці flowers.
Запуск з папки backend: python -m scripts.reseed_flowers

Увага: якщо є записи в detection_results, спочатку видаліть їх або видаліть flowers.db для чистого старту.
"""
import asyncio
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from sqlalchemy import delete

from app.database.connection import async_session_maker
from app.models.flower import Flower
from app.database.seed import INITIAL_FLOWERS


async def reseed():
    async with async_session_maker() as db:
        await db.execute(delete(Flower))
        for f in INITIAL_FLOWERS:
            db.add(Flower(**f))
        await db.commit()
    print(f"Flowers table reseeded with {len(INITIAL_FLOWERS)} flowers.")


if __name__ == "__main__":
    asyncio.run(reseed())
