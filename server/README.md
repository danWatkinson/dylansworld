# Server Setup

This directory contains the Docker configuration for the Minecraft server.

## Files

- `Dockerfile`: Server container definition
- `docker-compose.yml`: Docker Compose configuration
- `entrypoint.sh`: Server startup script

## Usage

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

Or from the repository root using the convenience scripts (to be added).

## Configuration

Server configuration is managed through the `.env` file in the repository root. See the main README for details.

