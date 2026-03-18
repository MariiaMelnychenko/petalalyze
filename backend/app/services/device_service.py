from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.device import Device


class DeviceService:
    @staticmethod
    async def get_or_create(db: AsyncSession, device_id: str) -> Device:
        result = await db.execute(select(Device).where(Device.device_id == device_id))
        device = result.scalar_one_or_none()
        if device is None:
            device = Device(device_id=device_id)
            db.add(device)
            await db.flush()
        return device
