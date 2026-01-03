#!/bin/bash
set -e

# Download PaperMC server if not exists
if [ ! -f "server.jar" ]; then
    echo "Downloading PaperMC server..."
    
    if [ "$MINECRAFT_VERSION" = "latest" ]; then
        PAPER_API="https://api.papermc.io/v2/projects/paper"
        MINECRAFT_VERSION=$(curl -s "$PAPER_API" | jq -r '.versions[-1]')
    fi
    
    if [ "$PAPER_BUILD" = "latest" ]; then
        BUILD_API="$PAPER_API/versions/$MINECRAFT_VERSION/builds"
        PAPER_BUILD=$(curl -s "$BUILD_API" | jq -r '.builds[-1].build')
    fi
    
    DOWNLOAD_URL="$PAPER_API/versions/$MINECRAFT_VERSION/builds/$PAPER_BUILD/downloads/paper-$MINECRAFT_VERSION-$PAPER_BUILD.jar"
    echo "Downloading from: $DOWNLOAD_URL"
    curl -L -o server.jar "$DOWNLOAD_URL"
fi

# Download GeyserMC plugin if not exists
if [ ! -f "plugins/Geyser-Spigot.jar" ]; then
    echo "Downloading GeyserMC plugin..."
    mkdir -p plugins
    
    GEYSER_API="https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest"
    GEYSER_INFO=$(curl -s "$GEYSER_API")
    GEYSER_DOWNLOAD=$(echo "$GEYSER_INFO" | jq -r '.downloads.spigot.url')
    
    if [ "$GEYSER_DOWNLOAD" = "null" ] || [ -z "$GEYSER_DOWNLOAD" ]; then
        echo "Warning: Could not get GeyserMC download URL, trying alternative method..."
        GEYSER_DOWNLOAD="https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot"
    fi
    
    echo "Downloading GeyserMC from: $GEYSER_DOWNLOAD"
    curl -L -o plugins/Geyser-Spigot.jar "$GEYSER_DOWNLOAD"
    
    if [ ! -f "plugins/Geyser-Spigot.jar" ]; then
        echo "Warning: GeyserMC download may have failed, but continuing..."
    fi
fi

# Check EULA
if [ "$EULA" != "true" ]; then
    echo "================================================"
    echo "ERROR: You must accept the Minecraft EULA!"
    echo "Set EULA=true environment variable"
    echo "================================================"
    exit 1
fi

# Create eula.txt if needed
if [ ! -f "eula.txt" ]; then
    echo "eula=true" > eula.txt
fi

# Create server.properties if it doesn't exist
if [ ! -f "server.properties" ]; then
    cat > server.properties <<EOF
# Minecraft Server Properties
server-port=25565
online-mode=true
level-name=world
enable-query=false
enable-rcon=false
difficulty=easy
gamemode=survival
max-players=20
view-distance=10
motd=A Minecraft Server
EOF
fi

# Set Java memory options
JAVA_OPTS="-Xms${MEMORY} -Xmx${MEMORY} -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

echo "Starting Minecraft server with Java options: $JAVA_OPTS"
exec java $JAVA_OPTS -jar server.jar nogui

