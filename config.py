# config.py
class Config:
    SECRET_KEY = 'a_very_secret_key_that_is_long_and_random' # CHANGE THIS IN PRODUCTION!
    DEBUG = False
    TESTING = False
    # Database connection details (still use env vars for sensitive parts)
    DB_USER = None # Will be set via environment variable
    DB_PASSWORD = None
    DB_HOST = None
    DB_PORT = None
    DB_SERVICE_NAME = None

class DevelopmentConfig(Config):
    DEBUG = True
    # Might use a local DB here
    DB_HOST = 'localhost'

class ProductionConfig(Config):
    # Production settings
    DB_HOST = 'your_hostinger_db_ip'
    # ...