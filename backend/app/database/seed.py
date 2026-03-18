"""Seed initial flowers data."""
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.flower import Flower

INITIAL_FLOWERS = [
    {"name": "Альстремерія", "latin_name": "Alstroemeria", "description": "Південноамериканська квітка з яскравими плямистими пелюстками. Популярна в букетах завдяки довготривалості.", "season": "літо"},
    {"name": "Антуріум", "latin_name": "Anthurium", "description": "Екзотична квітка з яскравим покривалом. Символізує гостинність та достаток.", "season": "круглий рік"},
    {"name": "Гвоздика садова", "latin_name": "Carnation", "description": "Класична квітка для букетів. Має приємний аромат та довго зберігає свіжість.", "season": "літо"},
    {"name": "Хризантема", "latin_name": "Chrysanthemum", "description": "Осіння квітка з багатьма відтінками. Символ довголіття та щастя в Азії.", "season": "осінь"},
    {"name": "Нарцис", "latin_name": "Daffodil", "description": "Весняна квітка з характерною короною. Один з перших вісників весни.", "season": "весна"},
    {"name": "Георгина", "latin_name": "Dahlia", "description": "Пишна квітка з множинними пелюстками. Різноманітність кольорів та форм.", "season": "літо-осінь"},
    {"name": "Гвоздика", "latin_name": "Dianthus", "description": "Делікатна квітка з перистими краями. Ідеальна для романтичних букетів.", "season": "літо"},
    {"name": "Плюмерія", "latin_name": "Frangipani", "description": "Тропічна квітка з інтенсивним ароматом. Часто використовується в гавайських леях.", "season": "літо"},
    {"name": "Гербера", "latin_name": "Gerbera", "description": "Яскрава квітка, схожа на соняшник. Піднімає настрій та енергію.", "season": "літо"},
    {"name": "Гладиолус", "latin_name": "Gladiolus", "description": "Висока квітка з кількома бутонами на стеблі. Символ сили характеру.", "season": "літо"},
    {"name": "Гіпеаструм", "latin_name": "Hippeastrum", "description": "Великі квіти на товстому стеблі. Популярна кімнатна та букетна квітка.", "season": "зима-весна"},
    {"name": "Гортензія", "latin_name": "Hydrangea", "description": "Кулясті суцвіття з дрібними квіточками. Любить вологу та підходить для тінистих місць.", "season": "літо"},
    {"name": "Ірис", "latin_name": "Iris", "description": "Квітка з елегантними пелюстками. Названа на честь грецької богині веселки.", "season": "весна"},
    {"name": "Протея королівська", "latin_name": "King Protea", "description": "Національна квітка ПАР. Великі екзотичні суцвіття.", "season": "весна-літо"},
    {"name": "Лотос", "latin_name": "Lotus", "description": "Священна квітка в багатьох культурах. Росте у водоймах.", "season": "літо"},
    {"name": "Орхідея місячна", "latin_name": "Moon Orchid", "description": "Елегантна орхідея з білими пелюстками. Символ чистоти та краси.", "season": "круглий рік"},
    {"name": "Нівяник", "latin_name": "Oxeye Daisy", "description": "Скромна польова квітка з білими пелюстками та жовтою серединкою.", "season": "літо"},
    {"name": "Півонія", "latin_name": "Paeonia", "description": "Пишна весняно-літня квітка. Символ процвітання та шлюбного щастя.", "season": "весна-літо"},
    {"name": "Георгина рожево-жовта", "latin_name": "Pink Yellow Dahlia", "description": "Георгина з градієнтом від рожевого до жовтого. Яскрава та незвичайна.", "season": "літо-осінь"},
    {"name": "Троянда", "latin_name": "Rose", "description": "Королева квітів. Символ любові, краси та досконалості.", "season": "літо"},
    {"name": "Соняшник", "latin_name": "Sunflower", "description": "Велика яскрава квітка, що слідкує за сонцем. Символ оптимізму.", "season": "літо"},
    {"name": "Тюльпан", "latin_name": "Tulip", "description": "Весняна квітка з елегантною формою. Асоціюється з Нідерландами.", "season": "весна"},
    {"name": "Калла", "latin_name": "Zantedeschia", "description": "Елегантна квітка з характерним покривалом. Популярна у весільних букетах.", "season": "літо"},
]

# Mapping folder_name -> index for ML model (0-based)
FLOWER_CLASS_ORDER = [
    "alstroemeria", "anthurium", "carnation", "chrysanthemum", "daffodil",
    "dahlia", "dianthus", "frangipani", "gerbera", "gladiolus", "hippeastrum",
    "hydrangea", "iris", "king_protea", "lotus", "moon_orchid", "oxeye_daisy",
    "paeonia", "pink_yellow_dahlia", "rose", "sunflower", "tulip", "zantedeschia",
]


async def seed_flowers(db: AsyncSession) -> None:
    result = await db.execute(select(Flower).limit(1))
    if result.scalar_one_or_none() is not None:
        return  # Already seeded

    for f in INITIAL_FLOWERS:
        flower = Flower(**f)
        db.add(flower)
    await db.commit()
