from application.main import app
from application.database import migrate_db
import os

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=os.environ["SERVER_PORT"], debug=False)