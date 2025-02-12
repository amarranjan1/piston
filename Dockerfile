# Use the official Node.js image
FROM node:18

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone the Piston repository
RUN git clone https://github.com/engineer-man/piston.git /app

# Move to the cloned directory
WORKDIR /app

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Install Node.js dependencies
RUN npm install

# Build the project
RUN npm run build

# Expose port 80
EXPOSE 80

# Start the API
CMD ["node", "main.js"]
