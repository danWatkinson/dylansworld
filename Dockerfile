FROM eclipse-temurin:21-jdk-jammy

# Set working directory
WORKDIR /minecraft

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl jq && \
    rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /minecraft/plugins /minecraft/world /minecraft/logs

# Copy entrypoint script
COPY entrypoint.sh /minecraft/entrypoint.sh
RUN chmod +x /minecraft/entrypoint.sh

# Set environment variables
ENV MINECRAFT_VERSION=latest
ENV PAPER_BUILD=latest
ENV GEYSER_VERSION=latest
ENV MEMORY=2G
ENV EULA=false

# Expose ports
# 25565 for Java Edition
# 19132 for Bedrock Edition (UDP)
EXPOSE 25565/tcp 19132/udp

# Set volume mounts
VOLUME ["/minecraft/world", "/minecraft/plugins", "/minecraft/logs"]

# Run entrypoint
ENTRYPOINT ["/minecraft/entrypoint.sh"]

