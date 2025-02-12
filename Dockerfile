# Use Python as the base image
FROM python:3.10

# Set working directory
WORKDIR /app

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Clone the Piston repository
RUN git clone https://github.com/engineer-man/piston.git /app

# Move into the repository
WORKDIR /app

# Upgrade pip to avoid dependency issues
RUN pip install --upgrade pip

# Install dependencies
RUN pip install -r requirements.txt

# Expose port
EXPOSE 2000

# Run the API
CMD ["python", "main.py"]
