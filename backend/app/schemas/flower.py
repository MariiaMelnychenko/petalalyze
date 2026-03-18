from pydantic import BaseModel


class FlowerResponse(BaseModel):
    id: int
    name: str
    latin_name: str | None
    image_url: str | None

    class Config:
        from_attributes = True


class FlowerDetailResponse(BaseModel):
    id: int
    name: str
    latin_name: str | None
    description: str | None
    season: str | None
    image_url: str | None

    class Config:
        from_attributes = True
