FROM surrealdb/surrealdb:latest

# Create a new image based on the original
# First, install minimal shell support
FROM ubuntu:22.04 AS build

# Copy the surreal binary from the original image
COPY --from=0 /surreal /surreal

# Make it executable
RUN chmod +x /surreal

# Set up our entrypoint script that can handle the PORT variable
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'PORT=${PORT:-8000}' >> /entrypoint.sh && \
    echo 'exec /surreal start --bind 0.0.0.0:$PORT' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Set the entrypoint to our script
ENTRYPOINT ["/entrypoint.sh"]