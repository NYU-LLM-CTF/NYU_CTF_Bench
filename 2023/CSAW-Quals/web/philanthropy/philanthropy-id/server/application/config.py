import os

class Config(object):
    ADMIN_USERNAME = 'otacon@protonmail.com'
    ADMIN_PASSWORD = '7cfqZrvYcbhQ6_Tbmn4jfxEAX2Q7ELqW'

    DB_HOST = os.environ["DB_HOST"]
    DB_USERNAME = os.environ["DB_USERNAME"]
    DB_PASSWORD = os.environ["DB_PASSWORD"]
    DB_PORT = os.environ["DB_PORT"]

    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = os.environ["JWT_SECRET_KEY"]
    JWT_TOKEN_LOCATION = ['cookies']
    JWT_COOKIE_CSRF_PROTECT = False
    
