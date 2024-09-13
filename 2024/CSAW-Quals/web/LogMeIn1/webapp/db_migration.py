from app import app
from models import migrate_db

with app.app_context():
    migrate_db()