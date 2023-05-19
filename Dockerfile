# Use a Linux base image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y unzip gawk

# Set the working directory to /app
WORKDIR /app

# Copy the script and data directory into the container
COPY cnefe2csv.sh /app/cnefe2csv.sh
COPY data /app/data

# Make the script executable
RUN chmod +x /app/cnefe2csv.sh

# Run the script when the container starts
CMD ["/bin/bash", "/app/cnefe2csv.sh"]

