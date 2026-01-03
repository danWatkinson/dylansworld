# Dockerized Minecraft Server (Java + Bedrock/Nintendo Switch)

This setup provides a Dockerized Minecraft server that supports both:
- **Java Edition** clients (PC, Mac, Linux)
- **Bedrock Edition** clients (Nintendo Switch, Xbox, PlayStation, Mobile, Windows 10/11)

## How It Works

The server uses:
- **PaperMC**: A high-performance fork of Spigot for Java Edition
- **GeyserMC**: A plugin/proxy that translates Bedrock protocol to Java protocol, allowing Bedrock clients to connect

## Quick Start

1. **Clone or download this repository**

2. **Set up environment variables:**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` to customize your server configuration (memory, versions, etc.). The `.env` file is git-ignored and contains your local settings.

3. **Start the server:**
   ```bash
   docker compose up -d
   ```
   
   **Note**: If you're using Docker Compose V1 (older installations), use `docker-compose` instead of `docker compose`.

4. **View logs:**
   ```bash
   docker compose logs -f
   ```

5. **Stop the server:**
   ```bash
   docker compose down
   ```

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

The `server.properties` file will be created automatically on first run. You can mount your own by uncommenting the volume mount in `docker-compose.yml`.

### Security Notes

**No Default Credentials**: This server setup does not include any default username/password combinations. 

- **RCON**: Remote Console (RCON) is **disabled by default** for security. If you enable RCON in `server.properties` by setting `enable-rcon=true`, you **MUST** set a strong password using `rcon.password=your-strong-password`. Never enable RCON without setting a secure password.

- **Player Authentication**: The server uses online mode by default, which requires players to authenticate with their Mojang/Microsoft accounts. No server-side passwords are required for players.

- **Environment Variables**: All configuration is stored in `.env` (git-ignored) to prevent exposing settings publicly.

## Connecting to the Server

### Java Edition Clients

1. Open Minecraft Java Edition
2. Click "Multiplayer"
3. Click "Add Server"
4. Enter your server IP address (or `localhost` if connecting from the same machine)
5. Port is `25565` (default, can be omitted)

### Nintendo Switch / Bedrock Edition Clients

1. Open Minecraft on your Nintendo Switch
2. Go to "Play" → "Servers" tab
3. Scroll down to find "Add Server" or use one of the empty server slots
4. Enter:
   - **Server Name**: Any name you want
   - **Server Address**: Your server's IP address
   - **Port**: `19132`
5. Save and connect

**Note**: If you're connecting from outside your local network, you'll need to:
- Configure port forwarding on your router (ports 25565 TCP and 19132 UDP)
- Use your public IP address

## Data Persistence

The server data is stored in:
- `./data/`: World files
- `./plugins/`: Plugin files (GeyserMC will be auto-downloaded)
- `./logs/`: Server logs
- `./server.properties`: Server configuration

## GeyserMC Configuration

After first run, GeyserMC will generate configuration files in `plugins/Geyser-Spigot/`. Key settings:

- **Bedrock Port**: Default is `19132`
- **Authentication**: Set in `config.yml` (default uses online mode)
- **Remote Server**: If using standalone mode (not included here)

You can edit the Geyser config by mounting the config directory or copying it out of the container.

## Troubleshooting

### Server won't start

- Make sure you've created a `.env` file from `.env.example`
- Make sure `EULA=true` is set in your `.env` file
- Check logs: `docker compose logs` (or `docker-compose logs` for V1)
- Ensure ports are not already in use

### Can't connect from Bedrock clients

- Verify the UDP port `19132` is open and forwarded
- Check GeyserMC logs in `plugins/Geyser-Spigot/`
- Make sure GeyserMC plugin loaded successfully (check server logs)
- Try disabling online mode temporarily to test (set `online-mode=false` in `server.properties`)

### Performance Issues

- Increase `MEMORY` environment variable (e.g., `4G` or `8G`)
- Adjust view distance in `server.properties`
- Consider using a more powerful server/computer

## Building the Image

To build the Docker image manually:

```bash
docker build -t minecraft-server .
```

## License

This setup uses:
- PaperMC (GPLv3)
- GeyserMC (MIT)
- Minecraft (Mojang - requires EULA acceptance)

