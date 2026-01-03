# Repository Structure

This document explains the organization of the Dylan's World repository.

## Directory Layout

```
dylansworld/
│
├── server/                    # Server Docker configuration
│   ├── Dockerfile            # Docker image definition
│   ├── docker-compose.yml    # Docker Compose configuration
│   ├── entrypoint.sh         # Server startup script
│   └── README.md             # Server-specific documentation
│
├── plugins/                   # Plugin development workspace
│   ├── custom/               # Source code for custom plugins
│   │   ├── landscape-generator/  # (future) Landscape generation plugin
│   │   ├── feature-generator/    # (future) Feature generation plugin
│   │   └── poi-generator/        # (future) Points of Interest plugin
│   ├── build/                # Build outputs (git-ignored)
│   └── README.md             # Plugin development guide
│
├── runtime/                   # Server runtime data (git-ignored)
│   ├── data/                 # World files and server data
│   ├── logs/                 # Server logs
│   └── plugins/              # Runtime plugins
│       ├── Geyser-Spigot/    # GeyserMC plugin (auto-downloaded)
│       └── *.jar             # Custom and third-party plugins
│
├── docs/                      # Documentation
│   └── STRUCTURE.md          # This file
│
├── .env.example              # Environment variable template
├── .env                      # Local environment variables (git-ignored)
├── .gitignore                # Git ignore rules
└── README.md                 # Main project README

```

## Purpose of Each Directory

### `server/`
Contains all Docker-related configuration for running the Minecraft server. This is separated to keep server infrastructure code separate from plugin development code.

### `plugins/`
The workspace for developing custom Minecraft plugins. 
- `custom/` contains the source code for each plugin
- `build/` contains compiled artifacts (git-ignored)
- Each plugin should have its own subdirectory with its build configuration

### `runtime/`
Contains all runtime server data that is generated when the server runs. This directory is git-ignored because:
- World files can be large
- Logs are generated automatically
- Plugins are either auto-downloaded or built from source
- Configuration files are generated automatically

### `docs/`
Documentation files for the project. This includes architecture decisions, setup guides, and development documentation.

## Development Workflow

1. **Server Setup**: Configure the server in `server/` directory
2. **Plugin Development**: Develop plugins in `plugins/custom/`
3. **Build**: Build plugins (outputs go to `plugins/build/`)
4. **Deploy**: Copy built plugins to `runtime/plugins/`
5. **Test**: Run the server using Docker Compose from `server/` directory
6. **Runtime Data**: All server data is stored in `runtime/` (git-ignored)

## Future Additions

As the project grows, consider adding:
- `scripts/` - Helper scripts for building, deploying, testing
- `plugins/custom/landscape-generator/` - Landscape generation plugin
- `plugins/custom/feature-generator/` - Feature generation plugin
- `plugins/custom/poi-generator/` - POI generation plugin
- `docs/ARCHITECTURE.md` - Plugin architecture documentation
- `docs/API.md` - Plugin API documentation

