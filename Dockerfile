# Include Python
FROM python:3.10-alpine

# Define your working directory
WORKDIR /

# Add your handler
ADD src/start.sh src/rp_handler.py requirements.txt ./
RUN chmod +x /start.sh

# Start the container
CMD /start.sh