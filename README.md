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

2. **Start the server:**
   ```bash
   docker compose up -d
   ```
   
   **Note**: If you're using Docker Compose V1 (older installations), use `docker-compose` instead of `docker compose`.

3. **View logs:**
   ```bash
   docker compose logs -f
   ```

4. **Stop the server:**
   ```bash
   docker compose down
   ```

## Configuration

### Environment Variables

Edit `docker-compose.yml` to customize:

- `EULA`: Must be set to `true` to accept Minecraft EULA (required)
- `MEMORY`: Java heap size (default: `2G`)
- `MINECRAFT_VERSION`: Minecraft version (default: `latest`)
- `PAPER_BUILD`: PaperMC build number (default: `latest`)
- `GEYSER_VERSION`: GeyserMC version (default: `latest`)

### Ports

- **25565/tcp**: Java Edition port
- **19132/udp**: Bedrock Edition (Nintendo Switch) port

Make sure these ports are open in your firewall/router.

### Server Properties

The `server.properties` file will be created automatically on first run. You can mount your own by uncommenting the volume mount in `docker-compose.yml`.

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

- Make sure `EULA=true` is set in `docker-compose.yml`
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

