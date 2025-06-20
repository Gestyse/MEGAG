# app.py
from flask import Flask, render_template, session, request # Vamos usar render_template para arquivos HTML reais
import os
import psycopg2 # O novo driver para PostgreSQL
from datetime import datetime

app = Flask(__name__)
app.secret_key = os.getenv('FLASK_SECRET_KEY', 'sua_chave_secreta_padrao_muito_longa_e_aleatoria')
# O ideal é que FLASK_SECRET_KEY também venha de uma variável de ambiente em produção.

# Configuração de conexão com o Banco de Dados PostgreSQL usando variáveis de ambiente
# As variáveis de ambiente serão definidas no docker-compose.yml
DB_USER = os.getenv('POSTGRES_USER')
DB_PASSWORD = os.getenv('POSTGRES_PASSWORD')
DB_HOST = os.getenv('POSTGRES_HOST') # Este será 'postgres-db' quando rodando no Docker Compose
DB_PORT = os.getenv('POSTGRES_PORT')
DB_NAME = os.getenv('POSTGRES_DB') # Nome do banco de dados dentro do PostgreSQL

def get_db_connection():
    """Estabelece e retorna uma conexão com o banco de dados PostgreSQL."""
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            dbname=DB_NAME
        )
        print("Conexão com o PostgreSQL Database estabelecida com sucesso!")
        return conn
    except psycopg2.Error as e:
        print(f"Erro ao conectar ao PostgreSQL Database: {e}")
        return None


def get_all_projects():
    """Busca todos os projetos do banco de dados."""
    projects = []
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT id, title, description, technologies, project_url, image_url, display_order FROM projects ORDER BY display_order ASC, id ASC")
            rows = cursor.fetchall()

            for row in rows:
                projects.append({
                    "id": row[0],
                    "title": row[1],
                    "description": row[2],
                    "technologies": row[3],
                    "project_url": row[4],
                    "image_url": row[5],
                    "display_order": row[6]
                })
            cursor.close()
        else:
            print("Não foi possível obter uma conexão para buscar projetos.")
    except psycopg2.Error as e:
        print(f"Erro ao consultar projetos do PostgreSQL: {e}")
    except Exception as e:
        print(f"Erro inesperado ao buscar projetos: {e}")
    finally:
        if conn:
            conn.close()
    return projects


# app.py (trecho, adicione aqui)
# ... (código get_all_projects() acima) ...

def get_all_experience():
    """Busca todas as experiências profissionais do banco de dados."""
    experiences = []
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        if conn:
            cursor = conn.cursor()
            # Ordenar por data de início, do mais recente para o mais antigo
            cursor.execute("SELECT id, job_title, company_name, location, start_date, end_date, description, display_order FROM experience ORDER BY display_order ASC, start_date DESC")
            rows = cursor.fetchall()

            for row in rows:
                experiences.append({
                    "id": row[0],
                    "job_title": row[1],
                    "company_name": row[2],
                    "location": row[3],
                    "start_date": row[4],
                    "end_date": row[5],
                    "description": row[6],
                    "display_order": row[7]
                })
            cursor.close()
        else:
            print("Não foi possível obter uma conexão para buscar experiências.")
    except psycopg2.Error as e:
        print(f"Erro ao consultar experiências do PostgreSQL: {e}")
    except Exception as e:
        print(f"Erro inesperado ao buscar experiências: {e}")
    finally:
        if conn:
            conn.close()
    return experiences

# app.py (trecho, adicione aqui)
# ... (código get_all_experience() acima) ...

def get_translations(lang_code):
    """Busca todas as traduções para um código de idioma específico."""
    translations = {}
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT key_name, text_content FROM translations WHERE lang_code = %s", (lang_code,))
            rows = cursor.fetchall()
            for row in rows:
                translations[row[0]] = row[1]
            cursor.close()
        else:
            print(f"Não foi possível obter uma conexão para buscar traduções para {lang_code}.")
    except psycopg2.Error as e:
        print(f"Erro ao consultar traduções do PostgreSQL: {e}")
    except Exception as e:
        print(f"Erro inesperado ao buscar traduções: {e}")
    finally:
        if conn:
            conn.close()
    return translations


@app.route('/<lang_code>') # Rota para lidar com o idioma na URL
@app.route('/')
def home(lang_code=None):
    # 1. Definir o idioma atual
    if lang_code:
        # Se o idioma estiver na URL, use-o e salve na sessão
        session['lang'] = lang_code
    elif 'lang' in session:
        # Se já houver um idioma na sessão, use-o
        lang_code = session['lang']
    else:
        # Se não houver, use o idioma padrão (Português de Portugal)
        lang_code = 'pt-PT'
        session['lang'] = 'pt-PT'

    # 2. Buscar dados pessoais e projetos/experiências (código existente)
    personal_info = None
    projects = []
    experiences = []
    conn = None
    try:
        conn = get_db_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT full_name, title, email, phone_number, linkedin_profile, github_profile, about_me, skills FROM personal_info WHERE id = 1")
            row = cursor.fetchone()

            if row:
                personal_info = {
                    "full_name": row[0],
                    "title": row[1],
                    "email": row[2],
                    "phone_number": row[3],
                    "linkedin_profile": row[4],
                    "github_profile": row[5],
                    "about_me": row[6],
                    "skills": row[7]
                }
            cursor.close()

            # --- Nova Chamada para Projetos ---
            projects = get_all_projects() # Chame a função aqui
            experiences = get_all_experience() # Chame a função aqui para garantir que as experiências sejam carregadas
            # --- Fim da Nova Chamada ---

        else:
            print("Não foi possível obter uma conexão com o banco de dados.")

    except psycopg2.Error as e:
        # ... tratamento de erro (mantenha o que já tinha) ...
        error_obj, = e.args # Descomente se usar psycopg2.Error diretamente
        print(f"Erro ao consultar dados: {error_obj.message}")
        personal_info = {"error": f"Não foi possível carregar as informações: {error_obj.message}"}
    except Exception as e:
        print(f"Erro inesperado: {e}")
        personal_info = {"error": f"Erro inesperado: {e}"}
    finally:
        if conn:
            conn.close()
    
    # 3. Buscar as traduções para o idioma atual
    translations = get_translations(lang_code)

    current_year = datetime.now().year # Obtém apenas o ano como um número

    # Passe 'current_year' para o template
    # 4. Passar TUDO para o template
    return render_template('index.html',
                           personal_info=personal_info,
                           projects=projects,
                           experiences=experiences,
                           current_year=current_year,
                           translations=translations, # NOVAS TRADUÇÕES AQUI
                           current_lang=lang_code) # Passar o idioma atual para o template


if __name__ == '__main__':
    # When running locally with 'python app.py'
    # debug=True provides helpful error messages in the browser
    # and automatically reloads the server on code changes.
    app.run(debug=True, port=5001)