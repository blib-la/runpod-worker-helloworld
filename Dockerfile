# Include Python
FROM python:3.10-alpine

# Label your image with metadata
LABEL maintainer="info@blib.la"
LABEL org.opencontainers.image.source https://github.com/blib-la/runpod-worker-helloworld
LABEL org.opencontainers.image.description "Getting started with a serverless endpoint on RunPod by creating a custom workerUI"

# Define your working directory
WORKDIR /

# Copy the requirements into the image
COPY requirements.txt ./

# Intall dependencies
RUN apk add --no-cache bash && \
    pip install --no-cache-dir -r requirements.txt

# Copy your source code into the image
COPY src/ .

# Make the start script executable
RUN chmod +x start.sh

# Run the start script
CMD ["/start.sh"]