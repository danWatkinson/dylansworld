# Plugins

This directory contains custom plugin development for the Minecraft server.

## Structure

```
plugins/
  custom/          # Source code for custom plugins
    landscape-generator/   # (future) Landscape generation plugin
    feature-generator/     # (future) Feature generation plugin
    poi-generator/         # (future) Points of Interest generation plugin
  build/          # Build outputs (git-ignored)
```

## Plugin Development

### Creating a New Plugin

1. Create a new directory under `plugins/custom/` for your plugin
2. Set up a Java/Kotlin project structure (Gradle or Maven recommended)
3. Add PaperMC/Spigot API as a dependency
4. Build your plugin using your build tool
5. Copy the built `.jar` file to `runtime/plugins/` for testing

### Build and Deploy

After building your plugin, copy it to the runtime plugins directory:

```bash
# From the repository root
cp plugins/build/your-plugin.jar runtime/plugins/
```

Or use the provided build script (to be created) that handles this automatically.

## Plugin Ideas

- **Landscape Generator**: Procedural landscape generation
- **Feature Generator**: Generate structures, biomes, terrain features
- **POI Generator**: Generate points of interest, landmarks, dungeons
- **World Builder**: Tools for world generation and modification

