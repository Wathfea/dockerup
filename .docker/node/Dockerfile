# Image
FROM node:14.15.4-alpine

# Set up work directory
ARG PROJECT_PATH
WORKDIR /var/www/${PROJECT_PATH}

# Configure host
ENV HOST 0.0.0.0

# Init command
ENTRYPOINT ["sh", "/var/www/docker/node/node.sh"]
