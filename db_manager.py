# db_manager.py (example snippet)
import cx_Oracle
import os

def get_db_connection():
    try:
        # Use environment variables for sensitive credentials
        connection = cx_Oracle.connect(
            os.getenv('DB_USER'),
            os.getenv('DB_PASSWORD'),
            f"{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_SERVICE_NAME')}"
        )
        return connection
    except cx_Oracle.Error as e:
        print(f"Error connecting to database: {e}")
        return None

def get_personal_info():
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT full_name, title, email, about_me, skills FROM personal_info WHERE id = 1")
            row = cursor.fetchone()
            if row:
                return {
                    "full_name": row[0],
                    "title": row[1],
                    "email": row[2],
                    "about_me": row[3],
                    "skills": row[4]
                }
            return None
    except cx_Oracle.Error as e:
        print(f"Error fetching personal info: {e}")
        return None
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()