# Competitive Eating — Project Context

Shared Roblox dev context (language, architecture, MCP, coding rules) is in the parent `Roblox/CLAUDE.md`.

## Project
Competitive eating game. Players upgrade their biology (stomach size, jaw speed, etc.) to beat NPC and live opponents in eating contests. Active mini-game core, upgrade shop progression, leaderboard competition.

## Core Game Loop
1. Player enters eating contest arena
2. Mini-game: hold/tap to eat food as fast as possible (fill bar, beat opponents)
3. Win → earn coins
4. Spend coins in upgrade shop (stomach capacity, jaw speed, swallow rate, focus)
5. Enter harder contests with bigger prizes
6. NPC opponents fill empty slots — real players slot in when online

## Monetization (post 15-min gate)
- Cosmetic character upgrades (giant mouth animations, glowing stomach, trophy poses)
- VIP: +20% coin earnings, exclusive outfit
- Developer Products: consumable speed boosts
- Game Passes: permanent stat bonuses
- Dual currency: Coins (gameplay only) / Style Bucks (cosmetics, earnable + purchasable)
- Never sell stat upgrades for Robux — ever

## Key Design Refs
- Full game design doc: `GAME_DESIGN.md`
- Rojo sync: `cd ~/Roblox/Competitive\ Eating && rojo serve`
