# Use the official Python base image, which is a slim version of Python 3.8
# This is a smaller image with only essential packages to keep the container lightweight
FROM python:3.8-slim

# Set the working directory in the container to /app
# All subsequent commands will be run in this directory
WORKDIR /app

# Copy the local 'packages' directory (containing downloaded dependencies) into the container's /packages directory
# This step is used to leverage pre-downloaded packages for installation
COPY packages /packages

# Install Flask and other dependencies from the copied local packages directory
# This step ensures that the container has all the necessary Python packages installed
RUN pip install /packages/*

# Copy the contents of the current local directory (where the Dockerfile resides) into the container's /app directory
# This includes the application code and other necessary files
COPY . /app

# Expose port 8000 to allow external access to this port
# This port will be used by the Flask server to listen for incoming requests
EXPOSE 8000

# Define the command to run the application when the container starts
# This command runs the CreateServer.py script using Python
CMD ["python", "CreateServer.py"]

