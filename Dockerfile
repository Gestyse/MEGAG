# Dockerfile
# Use a slim Python image for smaller size, suitable for deployment
#3.12.10
FROM python:3.10-slim-bookworm

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file first to leverage Docker's cache
# This ensures that pip install only runs if requirements.txt changes
COPY requirements.txt .

# Install Python dependencies
# --no-cache-dir: Reduces image size by not storing build cache
# -r requirements.txt: Installs packages listed in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code
# The '.' indicates the current directory on your host, '/app' is the target in container
COPY . .

# Expose the port your Flask application will listen on
# (This is more for documentation and firewall configuration than strict functionality)
# EXPOSE 5001
# O contêiner expõe a porta 5000 internamente
EXPOSE 5000 

# Command to run your Flask application
# We'll use Gunicorn, a production-ready WSGI HTTP server, instead of Flask's dev server.
# -w 4: Runs 4 worker processes (adjust based on your CPU cores)
# -b 0.0.0.0:5000: Binds to all network interfaces on port 5000
# app:app: Points to your Flask application instance named 'app' in 'app.py'
#CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5001", "app:app"]
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]