# Dockerfile
FROM python:3.10-slim-bookworm

# Instala ferramentas de build e dependências comuns necessárias para compilar pacotes Python
# 'build-essential' fornece compiladores C/C++
# 'libffi-dev', 'libssl-dev' e 'libsqlite3-dev' são dependências comuns para muitos pacotes Python
# 'libaio1' pode não ser necessário para python-oracledb em Thin Mode, mas manteremos por segurança.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libffi-dev \
    libssl-dev \
    libsqlite3-dev \
    libaio1 \
    && rm -rf /var/lib/apt/lists/*

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copiar o requirements.txt primeiro para aproveitar o cache do Docker
COPY requirements.txt .

# Instalar as dependências Python
# O --no-binary :all: força o pip a tentar compilar TODOS os pacotes, o que é um último recurso
# Mas vamos tentar sem ele primeiro. Se falhar, podemos adicionar.
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o restante do código da sua aplicação
COPY . .

# Expor a porta que sua aplicação Flask ouvirá
EXPOSE 5000

# Comando para rodar sua aplicação Flask usando Gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]