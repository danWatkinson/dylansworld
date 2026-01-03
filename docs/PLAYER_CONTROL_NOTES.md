# Player Control Implementation Notes

## Overview

The feedback loop requires controlling a player entity in Minecraft to capture snapshots from optimal viewing angles. This document outlines the approach for player control.

## Player Control Strategy

### Player Entity Management

1. **Player Selection/Creation**:
   - Use an existing online player if available (preferable for testing with real clients)
   - Or create/manage an NPC (Non-Player Character) using PaperMC's NPC API or similar
   - For automated testing, we may need to simulate a player entity

2. **Player Control Capabilities** (PaperMC API):
   - `Player.teleport(Location)` - Teleport player to specific coordinates
   - `Player.setFlying(boolean)` - Enable/disable flight mode
   - `Player.setAllowFlight(boolean)` - Allow flight permission
   - `Player.setFlySpeed(float)` - Control flight speed
   - `Player.teleport(location, PlayerTeleportEvent.TeleportCause)` - Teleport with cause
   - `Location.setYaw(float)` and `Location.setPitch(float)` - Set player orientation

### Optimal View Position Calculation

The system needs to calculate optimal viewing positions for structures:

1. **Calculate structure bounds** (min/max X, Y, Z coordinates)
2. **Determine viewing angle**:
   - Front view: Face the front of the structure
   - Isometric view: 45-degree angle for better depth perception
   - Top-down view: For flat structures
3. **Calculate distance**:
   - Far enough to capture entire structure
   - Close enough to see details
   - Consider field of view (FOV) settings
4. **Calculate camera position**:
   - Center structure in view
   - Account for structure height/width ratios

### Snapshot Capture Approaches

1. **Server-Side Screenshot** (if available):
   - Some server plugins/APIs may allow server-side rendering
   - Check PaperMC extensions/plugins

2. **Client-Side Screenshot** (recommended):
   - Use a dedicated client/player
   - Programmatically trigger screenshot capture
   - May require external tooling or bot framework

3. **Render API** (if available):
   - Use server rendering APIs if PaperMC/Spigot provides them
   - Generate image from world data directly

### Implementation Considerations

- **Player Authentication**: If using a real player account, handle authentication
- **Permission Management**: Ensure player has necessary permissions (fly, teleport)
- **World Safety**: Validate coordinates to prevent teleporting into blocks/walls
- **Performance**: Minimize teleport delays, batch operations when possible
- **Error Handling**: Handle cases where player is offline, disconnected, or in invalid state

## Testing Strategy

- Mock player entities for unit tests
- Integration tests with test server and test player account
- Validate teleport coordinates before execution
- Test flight mode transitions
- Test orientation setting accuracy

## PaperMC API References

Key classes/interfaces:
- `org.bukkit.entity.Player`
- `org.bukkit.Location`
- `org.bukkit.event.player.PlayerTeleportEvent`

