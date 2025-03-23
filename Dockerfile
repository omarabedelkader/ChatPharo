# Use a base image depending on the SMALLTALK_VERSION argument
ARG SMALLTALK_VERSION
FROM pharoproject/pharo:$SMALLTALK_VERSION

# Set working directory
WORKDIR /app

# Copy your project files into the image (assuming you have a project)
COPY . /app

# Optionally install additional dependencies here
# RUN apt-get update && apt-get install -y curl

# Default command
CMD ["pharo", "--version"]
