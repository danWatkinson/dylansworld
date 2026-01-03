# Dylan's World - Minecraft Server & Plugin Development

A Dockerized Minecraft server setup with support for both Java and Bedrock (Nintendo Switch) clients, plus a development workspace for creating custom plugins, world generators, and content.

## Features

- **Multi-platform Server**: Supports Java Edition (PC/Mac/Linux) and Bedrock Edition (Nintendo Switch, Xbox, PlayStation, Mobile)
- **Plugin Development Workspace**: Organized structure for developing custom Minecraft plugins
- **World Generation Tools**: Ready for building landscape, feature, and POI generators
- **Dockerized**: Easy setup and deployment using Docker

## Project Structure

```
dylansworld/
├── server/              # Server Docker configuration
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── entrypoint.sh
├── plugins/             # Plugin development workspace
│   ├── custom/          # Source code for custom plugins
│   │   ├── landscape-generator/  # (future)
│   │   ├── feature-generator/    # (future)
│   │   └── poi-generator/        # (future)
│   └── build/           # Build outputs (git-ignored)
├── runtime/             # Server runtime data (git-ignored)
│   ├── data/            # World files
│   ├── logs/            # Server logs
│   └── plugins/         # Runtime plugins (GeyserMC, custom plugins)
├── docs/                # Documentation
├── .env.example         # Environment variable template
└── README.md            # This file
```

## Quick Start

### 1. Set Up Environment

```bash
# Clone the repository
git clone https://github.com/danWatkinson/dylansworld.git
cd dylansworld

# Set up environment variables
cp .env.example .env
# Edit .env to configure your server
```

### 2. Start the Server

From the repository root:

```bash
# Start the server
cd server
docker compose up -d

# View logs
docker compose logs -f

# Stop the server
docker compose down
```

**Note**: If you're using Docker Compose V1 (older installations), use `docker-compose` instead of `docker compose`.

### 3. Connect to the Server

#### Java Edition Clients
1. Open Minecraft Java Edition
2. Click "Multiplayer" → "Add Server"
3. Enter your server IP address (or `localhost` if connecting from the same machine)
4. Port is `25565` (default, can be omitted)

#### Nintendo Switch / Bedrock Edition Clients
1. Open Minecraft on your Nintendo Switch
2. Go to "Play" → "Servers" tab
3. Click "Add Server"
4. Enter:
   - **Server Name**: Any name you want
   - **Server Address**: Your server's IP address
   - **Port**: `19132`
5. Save and connect

**Note**: If connecting from outside your local network, configure port forwarding on your router (ports 25565 TCP and 19132 UDP) and use your public IP address.

## Configuration

### Environment Variables

Configuration is managed through the `.env` file. Copy `.env.example` to `.env` and customize as needed:

```bash
cp .env.example .env
```

The `.env` file contains:
- `EULA`: Must be set to `true` to accept Minecraft EULA (required)
- `MEMORY`: Java heap size (default: `2G`). Adjust based on available system resources (e.g., `4G`, `8G`)
- `MINECRAFT_VERSION`: Minecraft version (default: `latest`, or specify like `1.20.1`)
- `PAPER_BUILD`: PaperMC build number (default: `latest`, or specify a build number)
- `GEYSER_VERSION`: GeyserMC version (default: `latest`, or specify a version)

**Important**: The `.env` file is git-ignored and will not be committed to the repository. This ensures your local configuration (including the EULA acceptance) stays private. Always copy `.env.example` to `.env` when setting up a new deployment.

### Ports

- **25565/tcp**: Java Edition port
- **19132/udp**: Bedrock Edition (Nintendo Switch) port

Make sure these ports are open in your firewall/router.

### Server Properties

The `server.properties` file will be created automatically on first run in the server container. You can customize it by copying it from the container or mounting a custom file.

## Plugin Development

This repository is organized for developing custom Minecraft plugins. See [`plugins/README.md`](plugins/README.md) for details on plugin development.

### Planned Plugins

- **Landscape Generator**: Procedural landscape generation
- **Feature Generator**: Generate structures, biomes, terrain features
- **POI Generator**: Generate points of interest, landmarks, dungeons

### Building and Testing Plugins

1. Develop your plugin in `plugins/custom/your-plugin/`
2. Build your plugin using your build tool (Gradle/Maven)
3. Copy the built `.jar` to `runtime/plugins/`
4. Restart the server to load the plugin

## Server Components

The server uses:
- **PaperMC**: A high-performance fork of Spigot for Java Edition
- **GeyserMC**: A plugin/proxy that translates Bedrock protocol to Java protocol, allowing Bedrock clients to connect

## Security Notes

**No Default Credentials**: This server setup does not include any default username/password combinations. 

- **RCON**: Remote Console (RCON) is **disabled by default** for security. If you enable RCON in `server.properties` by setting `enable-rcon=true`, you **MUST** set a strong password using `rcon.password=your-strong-password`. Never enable RCON without setting a secure password.

- **Player Authentication**: The server uses online mode by default, which requires players to authenticate with their Mojang/Microsoft accounts. No server-side passwords are required for players.

- **Environment Variables**: All configuration is stored in `.env` (git-ignored) to prevent exposing settings publicly.

## Troubleshooting

### Server won't start

- Make sure you've created a `.env` file from `.env.example`
- Make sure `EULA=true` is set in your `.env` file
- Check logs: `docker compose logs` (or `docker-compose logs` for V1)
- Ensure ports are not already in use
- Make sure you're running commands from the `server/` directory

### Can't connect from Bedrock clients

- Verify the UDP port `19132` is open and forwarded
- Check GeyserMC logs in `runtime/plugins/Geyser-Spigot/`
- Make sure GeyserMC plugin loaded successfully (check server logs)
- Try disabling online mode temporarily to test (set `online-mode=false` in `server.properties`)

### Performance Issues

- Increase `MEMORY` environment variable (e.g., `4G` or `8G`)
- Adjust view distance in `server.properties`
- Consider using a more powerful server/computer

## Building the Docker Image

To build the Docker image manually:

```bash
cd server
docker build -t minecraft-server .
```

## License

This setup uses:
- PaperMC (GPLv3)
- GeyserMC (MIT)
- Minecraft (Mojang - requires EULA acceptance)

## Contributing

This is a personal project for developing custom Minecraft plugins and world generation tools. See the plugin development section for details on the planned features.
