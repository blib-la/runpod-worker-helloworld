# Include Python
FROM python:3.10-alpine

# Define your working directory
WORKDIR /

# Add your src
ADD src/start.sh src/rp_handler.py requirements.txt ./
RUN chmod +x /start.sh

# Intall dependencies
RUN pip install -r requirements.txt

# Run the start script
CMD /start.sh