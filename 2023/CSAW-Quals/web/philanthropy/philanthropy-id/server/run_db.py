from application.main import app
from application.database import migrate_db
import os

with app.app_context():
    migrate_db()
