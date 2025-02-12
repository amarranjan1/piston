FROM python:3.10

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone the Piston API repository
RUN git clone https://github.com/engineer-man/piston.git /app

# Install Piston API dependencies
RUN pip install -r requirements.txt

# Expose port 80 for API access
EXPOSE 80

# Run the API
CMD ["python", "main.py"]
