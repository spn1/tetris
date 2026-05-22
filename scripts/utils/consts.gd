extends Node

const GRID_INCREMENT: int = 10
const BOARD_COLUMNS: int = 10
const BOARD_ROWS: int = 22 # 2 rows hidden at the top so pieces appear outside the board
const VISIBLE_ROWS: int = 20

enum Piece { I = 0, O = 1, T = 2, S = 3, Z = 4, J = 5, L = 6 }
enum Rotation { SPAWN = 0, SW = 1, FLIP = 2, CCW = 3 }

const PIECES: Array = [
	  #Piece.I  — 4×4 bounding box
	 [
		 [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(3,1)],  # SPAWN
		 [Vector2i(2,0), Vector2i(2,1), Vector2i(2,2), Vector2i(2,3)],  # CW
		 [Vector2i(0,2), Vector2i(1,2), Vector2i(2,2), Vector2i(3,2)],  # FLIP
		 [Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(1,3)],  # CCW
	 ],
	 # Piece.O  — 2×2, doesn't rotate
	 [
		 [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
		 [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
		 [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
		 [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
	 ],
	 # Piece.T  — 3×3
	 [
		 [Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)],  # SPAWN
		 [Vector2i(1,0), Vector2i(1,1), Vector2i(2,1), Vector2i(1,2)],  # CW
		 [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(1,2)],  # FLIP
		 [Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(1,2)],  # CCW
	 ],
	 # Piece.S  — 3×3
	 [
		 [Vector2i(1,0), Vector2i(2,0), Vector2i(0,1), Vector2i(1,1)],  # SPAWN
		 [Vector2i(1,0), Vector2i(1,1), Vector2i(2,1), Vector2i(2,2)],  # CW
		 [Vector2i(1,1), Vector2i(2,1), Vector2i(0,2), Vector2i(1,2)],  # FLIP
		 [Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(1,2)],  # CCW
	 ],
	 # Piece.Z  — 3×3
	 [
		 [Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(2,1)],  # SPAWN
		 [Vector2i(2,0), Vector2i(1,1), Vector2i(2,1), Vector2i(1,2)],  # CW
		 [Vector2i(0,1), Vector2i(1,1), Vector2i(1,2), Vector2i(2,2)],  # FLIP
		 [Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(0,2)],  # CCW
	 ],
	 # Piece.J  — 3×3
	 [
		 [Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)],  # SPAWN
		 [Vector2i(1,0), Vector2i(2,0), Vector2i(1,1), Vector2i(1,2)],  # CW
		 [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(2,2)],  # FLIP
		 [Vector2i(1,0), Vector2i(1,1), Vector2i(0,2), Vector2i(1,2)],  # CCW
	 ],
	 # Piece.L  — 3×3
	 [
		 [Vector2i(2,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)],  # SPAWN
		 [Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(2,2)],  # CW
		 [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(0,2)],  # FLIP
		 [Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(1,2)],  # CCW
	 ],
]

const PIECE_ATLAS_COORDS: Array[Vector2i] = [
	Vector2i(5, 0), # I red
	Vector2i(6, 0), # O yellow
	Vector2i(1, 0), # T cyan
	Vector2i(4, 0), # S purple
	Vector2i(2, 0), # Z green
	Vector2i(0, 0), # J blue
	Vector2i(3, 0), # L pink
]

# DAS - Delayed Auto Shift - Short Delay before repeated movement from held-down input
const DAS_DELAY: float = 0.167 # seconds before held movement auto-repeats
const ARR_RATE: float = 0.1 # seconds between auto-repeat shifts
const LOCK_DELAY: float = 0.5 # seconds before a grounded piece locks
