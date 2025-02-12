# Use Python as the base image
FROM python:3.10

# Set working directory
WORKDIR /app

# Copy files to the container
COPY . .  

# Upgrade pip
RUN pip install --upgrade pip

# Install dependencies
RUN pip install -r requirements.txt

# Expose port
EXPOSE 2000

# Run the API
CMD ["python", "main.py"]
