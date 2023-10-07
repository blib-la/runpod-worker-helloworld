# Include Python
FROM python:3.10-alpine

# Define your working directory
WORKDIR /

# Install runpod
RUN pip install runpod

# Add your handler
ADD rp_handler.py .

# Call your handler when the container starts
CMD [ "python", "-u", "/rp_handler.py" ]