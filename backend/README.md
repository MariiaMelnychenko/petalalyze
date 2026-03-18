# Flower Detection Backend API

Backend для мобільного застосунку розпізнавання квітів у букеті.

## Запуск

```bash
cd backend
python -m venv venv
.\venv\Scripts\Activate.ps1   # Windows PowerShell
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Сервер: http://localhost:8000  
Swagger: http://localhost:8000/docs

## Документація

**[ARCHITECTURE.md](ARCHITECTURE.md)** — архітектура, API endpoints, особливості, реалізовані методи.
