# Use Node.js as the base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy files to the container
COPY . .  

# Install dependencies
RUN npm install

# Expose port
EXPOSE 2000

# Run the API
CMD ["node", "api/src/index.js"]
