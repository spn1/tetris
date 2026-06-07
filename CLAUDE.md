# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Running the Game

Open the project in Godot 4.6 and press F5 (or use the Run button). There is no CLI build step — all development happens through the Godot editor. The gdscript-linter addon provides in-editor linting.

## Architecture

This is a Godot 4.6 Tetris clone. The scene tree is:

- **`scenes/main.tscn`** (`scripts/main.gd`) — Root node. Connects Board signals to GUI on ready, then calls `sync_ui()` to push initial state.
- **`scenes/board.tscn`** (`scripts/grid.gd`, class `Board`) — Core game logic: gravity, locking, line clears, scoring, hold, and the piece queue. Uses three `TileMapLayer` children (`LockedCells`, `ActivePieceTiles`, `GhostTiles`) for rendering.
- **`scenes/gui.tscn`** (`scripts/gui.gd`) — HUD rendered as a `CanvasLayer`. Receives signals from Board and redraws score/level/lines/queue/hold displays.

### Key Scripts

| File | Class | Purpose |
|------|-------|---------|
| `scripts/grid.gd` | `Board` | All game state: grid array, active piece, queue, hold, scoring |
| `scripts/active_piece.gd` | `ActivePiece` | Lightweight piece state (type, rotation, grid_pos); computes world cells |
| `scripts/input.gd` | — | Child of Board; translates input actions to Board method calls with DAS/ARR handling |
| `scripts/utils/consts.gd` | `Constants` | Autoloaded singleton with piece shapes, wall kick tables, atlas coords, timing constants |
| `scripts/utils/piece_factory.gd` | `PieceFactory` | Spawns pieces at the correct column; generates 7-bag shuffles |

### Data Model

- `grid` on `Board` is `grid[row][col]` — row 0 is the top. Value 0 = empty; 1–7 = piece color index.
- Piece shapes in `Constants.PIECES` use local offsets from a bounding-box origin, indexed `[Piece][Rotation]`.
- Wall kicks are separate tables for I-piece (`WALL_KICKS_I`) vs all others (`WALL_KICKS_JLSTZ`), keyed by `from_rotation → to_rotation`.
- The next-piece queue always holds 5 pieces drawn from a 7-bag (`_bag`). When the queue drops below 5, a new bag is generated.

### Signals (Board → GUI)

`score_changed`, `level_changed`, `lines_cleared`, `queue_changed`, `hold_changed`, `game_over`

### Input Actions (defined in `project.godot`)

| Action | Keys |
|--------|------|
| `move_left` / `move_right` | A/D or arrow keys |
| `rotate_left` / `rotate_right` | Q / E |
| `soft_drop` | S |
| `sonic_drop` | Space (hard drop) |
| `store_swap` | R (hold) |

### Timing Constants (`Constants`)

- `DAS_DELAY` — 0.167s before held movement auto-repeats
- `ARR_RATE` — 0.033s between auto-repeat shifts
- `LOCK_DELAY` — 0.5s before a grounded piece locks
- Drop interval — calculated from level via `pow(0.8 - (level-1)*0.007, level-1)`

## Collaboration Style
The user is learning Godot. Do not write code or make edits directly. Instead, explain concepts, point to relevant files/lines, and guide the user to write the solution themselves.

You communicate clearly and concisely. You do not praise, flatter, or encourage the user. Eliminate all social niceties and 'I understand' fillers. Provide direct, professional, and critical feedback. Prioritize efficiency and accuracy over agreeableness.
