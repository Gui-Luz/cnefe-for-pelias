# Use a Linux base image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y unzip gawk

# Set the working directory to /app
WORKDIR /app

# Copy the script and data directory into the container
COPY cnefe4pelias.sh /app/cnefe4pelias.sh
COPY municipios.csv /app/municipios.csv
COPY data /app/data

# Make the script executable
RUN chmod +x /app/cnefe4pelias.sh

# Run the script when the container starts
CMD ["/bin/bash", "/app/cnefe4pelias.sh"]
