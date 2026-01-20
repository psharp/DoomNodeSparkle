# DoomNodeSparkle

A World of Warcraft addon that adds sparkle effects near the cursor when mousing over gathering nodes and treasure chests.

## Compatibility

- **Vanilla WoW** (1.12.x, 1.15.x)
- **Classic Era** (1.15.x)
- **Classic TBC** (2.5.x)
- **Classic Wrath** (3.4.x)

## Features

- Displays a color-cycling pulsing sparkle animation when hovering over:
  - **Herbalism nodes** (Peacebloom, Silverleaf, etc.)
  - **Mining nodes** (Copper Vein, Iron Deposit, Thorium Vein, etc.)
  - **Fishing pools** (Oily Blackmouth School, Firefin Snapper School, etc.)
  - **Treasure chests** (Battered Chest, Solid Chest, etc.)
- **Rainbow color cycling** - Sparkles smoothly transition through bright green, white, yellow, and pink
- **Position locking** - Sparkle marks the initial screen position when you hover over a node
- **World objects only** - Won't trigger on bag items or UI elements
- Works with GameTooltip detection
- Lightweight and performant
- Modular design with separate files for each node type
- No dependencies required

## Known Limitations

**Camera Movement**: The sparkle marks the screen position where the node appears when you first mouse over it. If you rotate the camera while hovering over a node, the sparkle will remain at its original screen position rather than following the node's new position.

This is a limitation of the Vanilla WoW 1.12 API, which does not provide functions to:
- Convert 3D world coordinates to 2D screen coordinates
- Track world objects as the camera moves
- Anchor UI elements to world objects dynamically

The sparkle works perfectly when the camera is stationary and provides a clear visual indicator of node locations.

## Installation

1. Download or clone this repository
2. Copy the `DoomNodeSparkle` folder to your WoW addons directory:
   - **Vanilla/Classic**: `World of Warcraft\_classic_\Interface\AddOns\`
   - **Classic Era**: `World of Warcraft\_classic_era_\Interface\AddOns\`
   - **Retail**: `World of Warcraft\_retail_\Interface\AddOns\`
3. Restart WoW or type `/reload` in-game
4. The addon will automatically activate when you mouse over gathering nodes or treasure chests

## Development

This addon is written in Lua and follows WoW addon development best practices:

- Uses frame-based UI system
- Compatible with vanilla API (no modern WoW APIs)
- No external dependencies
- Manual animation system (no AnimationGroups for maximum compatibility)

## File Structure

```
DoomNodeSparkle/
├── DoomNodeSparkle.toc        # Addon manifest/metadata
├── DoomNodeSparkleHerb.lua    # Herbalism node detection
├── DoomNodeSparkleMining.lua  # Mining node detection
├── DoomNodeSparkleChest.lua   # Treasure chest detection
├── DoomNodeSparkleFishing.lua # Fishing pool detection
└── README.md                  # This file
```
detection logic in the respective node type files:
- `DoomNodeSparkleHerb.lua` for herbs
- `DoomNodeSparkleMining.lua` for mining nodes
- `DoomNodeSparkleChest.lua` for treasure chests
## Localization

Currently supports English tooltip detection. To add support for other languages, modify the detection logic in the respective node type files:
- `DoomNodeSparkleHerb.lua` for herbs
- `DoomNodeSparkleMining.lua` for mining nodes
- `DoomNodeSparkleChest.lua` for treasure chests
- `DoomNodeSparkleFishing.lua` for fishing pools

## Authors

- Doom
- Patriq
- Supafly
