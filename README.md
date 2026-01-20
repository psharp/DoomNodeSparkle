# DoomNodeSparkle

A World of Warcraft addon that adds sparkle effects near the cursor when mousing over gathering nodes and treasure chests.

## Compatibility

- **Vanilla WoW** (1.12.x, 1.15.x)
- **Classic Era** (1.15.x)
- **Classic TBC** (2.5.x)
- **Classic Wrath** (3.4.x)

## Features

- Displays a pulsing sparkle animation when hovering over:
  - **Herbalism nodes** (Peacebloom, Silverleaf, etc.)
  - **Mining nodes** (Copper Vein, Iron Deposit, Thorium Vein, etc.)
  - **Fishing pools** (Oily Blackmouth School, Firefin Snapper School, etc.)
  - **Treasure chests** (Battered Chest, Solid Chest, etc.)
- Works with GameTooltip detection
- Lightweight and performant
- Modular design with separate files for each node type
- No dependencies1. Download or clone this repository
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
