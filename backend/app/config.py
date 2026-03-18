from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    # За замовчуванням SQLite (без PostgreSQL)
    database_url: str = "sqlite+aiosqlite:///./flowers.db"
    database_url_sync: str = "sqlite:///./flowers.db"
    uploads_dir: str = "uploads"
    results_dir: str = "results"
    crops_dir: str = "crops"
    flowers_dir: str = "flowers"
    host: str = "0.0.0.0"
    port: int = 8000

    class Config:
        env_file = ".env"
        extra = "ignore"


@lru_cache
def get_settings() -> Settings:
    return Settings()
