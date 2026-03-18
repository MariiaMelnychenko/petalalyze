import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware
from pathlib import Path

from app.database import init_db, async_session_maker

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
from app.models import Device, Flower, Detection, DetectionResult  # noqa: F401 - register models
from app.routers import health, flowers, detections, detect
from app.utils.image_utils import ensure_directories
from app.database.seed import seed_flowers


@asynccontextmanager
async def lifespan(app: FastAPI):
    ensure_directories()
    await init_db()
    async with async_session_maker() as db:
        await seed_flowers(db)
    yield
    # cleanup if needed


app = FastAPI(
    title="Flower Detection API",
    description="Backend API for mobile flower recognition app",
    version="1.0.0",
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class RequestLoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        logger.info(">>> %s %s from %s", request.method, request.url.path, request.client.host if request.client else "?")
        response = await call_next(request)
        logger.info("<<< %s %s -> %s", request.method, request.url.path, response.status_code)
        return response


app.add_middleware(RequestLoggingMiddleware)

app.include_router(health.router)
app.include_router(detect.router)
app.include_router(flowers.router)
app.include_router(detections.router)

# Mount static files for uploads, results, crops
base_path = Path(__file__).resolve().parent.parent
for folder in ["uploads", "results", "crops", "flowers"]:
    path = base_path / folder
    path.mkdir(parents=True, exist_ok=True)
    app.mount(f"/{folder}", StaticFiles(directory=str(path)), name=folder)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
