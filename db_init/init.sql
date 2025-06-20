-- db_init/init.sql
-- Cria a tabela personal_info se ela não existir
CREATE TABLE IF NOT EXISTS personal_info (
    id SERIAL PRIMARY KEY, -- SERIAL para auto-incremento no PostgreSQL
    full_name VARCHAR(100) NOT NULL,
    title VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    linkedin_profile VARCHAR(255),
    github_profile VARCHAR(255),
    about_me TEXT, -- TEXT para textos longos no PostgreSQL (similar ao CLOB)
    skills VARCHAR(1000) -- Habilidades separadas por vírgula ou string JSON
);

-- Insere dados iniciais se a tabela estiver vazia
-- IMPORTANTE: Esta inserção só ocorrerá se a tabela estiver completamente vazia.
-- Se você já tem dados ou quer um controle mais manual, pode remover este bloco INSERT.
INSERT INTO personal_info (full_name, title, email, phone_number, linkedin_profile, github_profile, about_me, skills)
SELECT
    'GESTYSE',
    'Gestora de Trafego Pago e Analista de Dados',
    'thayse.jordao@gestyse.com',
    '+351 938 935 870',
    'https://linkedin.com/in/thaysejordao',
    'https://github.com/willanythayse',
    'Sou um analista de dados apaixonado por transformar dados brutos em insights acionáveis...',
    'Python, SQL, R, Tableau, Power BI, Machine Learning, Dashboards, Meta e Google Ads'
WHERE NOT EXISTS (SELECT 1 FROM personal_info WHERE id = 1); -- Evita inserir duplicatas

-- COMMIT é automático no PostgreSQL após um INSERT fora de uma transação explícita

-- Tabela para armazenar informações sobre os projetos
CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    technologies VARCHAR(500), -- Ex: 'Python, SQL, Tableau'
    project_url VARCHAR(255),  -- Link para o projeto (GitHub, dashboard, etc.)
    image_url VARCHAR(255),    -- URL de uma imagem/miniatura do projeto
    display_order INTEGER DEFAULT 0 -- Ordem de exibição (opcional)
);

-- Insere dados de exemplo para projetos
INSERT INTO projects (title, description, technologies, project_url, image_url, display_order)
SELECT 'Análise de Vendas para E-commerce',
       'Análise completa de dados de vendas, identificando tendências, produtos de alto desempenho e padrões de compra dos clientes. Utilização de técnicas de visualização de dados para criar dashboards interativos.',
       'Python, Pandas, Matplotlib, SQL, Power BI',
       'https://github.com/seunome/analise_e-commerce',
       '{{ url_for("static", filename="images/project1.png") }}', -- Placeholder
       1
WHERE NOT EXISTS (SELECT 1 FROM projects WHERE id = 1);

INSERT INTO projects (title, description, technologies, project_url, image_url, display_order)
SELECT 'Modelo Preditivo de Churn',
       'Desenvolvimento de um modelo de Machine Learning para prever a probabilidade de churn de clientes em uma empresa de telecomunicações, utilizando dados históricos de uso e comportamento.',
       'Python, Scikit-learn, Jupyter, PostgreSQL',
       'https://github.com/seunome/churn_prediction',
       '{{ url_for("static", filename="images/project2.png") }}', -- Placeholder
       2
WHERE NOT EXISTS (SELECT 1 FROM projects WHERE id = 2);

INSERT INTO projects (title, description, technologies, project_url, image_url, display_order)
SELECT 'Dashboard de Performance de Marketing',
       'Criação de um dashboard dinâmico no Tableau para monitorar métricas chave de marketing digital, como ROI, custo por clique e conversões, permitindo decisões estratégicas baseadas em dados.',
       'Tableau, SQL, Google Analytics',
       'https://public.tableau.com/profile/seunome/viz/MarketingDashboard',
       '{{ url_for("static", filename="images/gestyse.png") }}', -- Placeholder
       3
WHERE NOT EXISTS (SELECT 1 FROM projects WHERE id = 3);

-- db_init/init.sql (adicione no final do arquivo)

-- Tabela para armazenar informações sobre a experiência profissional
CREATE TABLE IF NOT EXISTS experience (
    id SERIAL PRIMARY KEY,
    job_title VARCHAR(255) NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    start_date DATE NOT NULL,
    end_date DATE, -- NULL se for o emprego atual
    description TEXT,
    display_order INTEGER DEFAULT 0
);

-- Insere dados de exemplo para experiência
INSERT INTO experience (job_title, company_name, location, start_date, end_date, description, display_order)
SELECT 'Analista de Dados Sênior',
       'Tech Solutions Corp.',
       'Lisboa, Portugal',
       '2022-03-15',
       NULL, -- NULL para emprego atual
       'Liderança em projetos de análise de dados para otimização de processos. Desenvolvimento de dashboards interativos e relatórios estratégicos para a diretoria. Mentoria de novos analistas.',
       1
WHERE NOT EXISTS (SELECT 1 FROM experience WHERE id = 1);

INSERT INTO experience (job_title, company_name, location, start_date, end_date, description, display_order)
SELECT 'Analista de Dados Júnior',
       'Data Insights Ltda.',
       'Porto, Portugal',
       '2020-07-01',
       '2022-03-10',
       'Coleta, limpeza e transformação de grandes volumes de dados. Criação de consultas SQL complexas e suporte a equipes de marketing e vendas com insights acionáveis.',
       2
WHERE NOT EXISTS (SELECT 1 FROM experience WHERE id = 2);

-- db_init/init.sql (adicione no final do arquivo)

-- Tabela para armazenar traduções de textos
CREATE TABLE IF NOT EXISTS translations (
    id SERIAL PRIMARY KEY,
    lang_code VARCHAR(10) NOT NULL, -- Ex: 'pt-PT', 'pt-BR', 'en', 'es'
    key_name VARCHAR(255) NOT NULL, -- Chave para o texto (ex: 'hero_greeting', 'about_title')
    text_content TEXT NOT NULL,     -- O texto traduzido
    UNIQUE (lang_code, key_name)    -- Garante que cada chave é única por idioma
);

-- Inserir traduções para Português (PT-PT)
INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'pt-PT', 'hero_greeting', 'Olá, eu sou'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'pt-PT' AND key_name = 'hero_greeting');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'pt-PT', 'about_title', 'Sobre Mim'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'pt-PT' AND key_name = 'about_title');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'pt-PT', 'experience_title', 'Experiência Profissional'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'pt-PT' AND key_name = 'experience_title');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'pt-PT', 'projects_title', 'Meus Projetos'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'pt-PT' AND key_name = 'projects_title');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'pt-PT', 'contact_title', 'Contacto'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'pt-PT' AND key_name = 'contact_title');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'pt-PT', 'view_project', 'Ver Projeto'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'pt-PT' AND key_name = 'view_project');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'pt-PT', 'current_job_label', 'Atual'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'pt-PT' AND key_name = 'current_job_label');

-- Inserir traduções para Inglês (EN) - APENAS COMO EXEMPLO!
-- Você precisará adicionar todas as traduções para todos os idiomas!
INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'en', 'hero_greeting', 'Hello, I am'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'en' AND key_name = 'hero_greeting');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'en', 'about_title', 'About Me'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'en' AND key_name = 'about_title');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'en', 'experience_title', 'Professional Experience'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'en' AND key_name = 'experience_title');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'en', 'projects_title', 'My Projects'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'en' AND key_name = 'projects_title');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'en', 'contact_title', 'Contact'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'en' AND key_name = 'contact_title');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'en', 'view_project', 'View Project'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'en' AND key_name = 'view_project');

INSERT INTO translations (lang_code, key_name, text_content)
SELECT 'en', 'current_job_label', 'Current'
WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'en' AND key_name = 'current_job_label');

-- Você precisará adicionar o mesmo para 'pt-BR' e 'es'
-- Exemplo:
-- INSERT INTO translations (lang_code, key_name, text_content)
-- SELECT 'pt-BR', 'hero_greeting', 'Olá, eu sou'
-- WHERE NOT EXISTS (SELECT 1 FROM translations WHERE lang_code = 'pt-BR' AND key_name = 'hero_greeting');