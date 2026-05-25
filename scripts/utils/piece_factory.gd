class_name PieceFactory
extends RefCounted

# Bounding Box - The smaller box that can contain all rotations of the piece
const _BBOX_WIDTHS: Dictionary = {
	Constants.Piece.I: 4,
	Constants.Piece.O: 2,
	Constants.Piece.T: 3,
	Constants.Piece.S: 3,
	Constants.Piece.Z: 3,
	Constants.Piece.J: 3,
	Constants.Piece.L: 3,
}


# Pieces chosen via the 7-bag rule:
	# Fill a bag with all 7 pieces.
	# Pieces are chosen randomly from the bag
	# Once the bag is empty, it is regenerated.
static func new_bag() -> Array:
	var bag: Array[Constants.Piece] = []
	for p in Constants.Piece.values():
		bag.append(p as Constants.Piece)
	bag.shuffle()
	return bag

# Spawns a piece at the top of the grid
static func spawn_piece(type: Constants.Piece) -> ActivePiece:
	var bbox_w: int = _BBOX_WIDTHS[type]
	var column: int = (Constants.BOARD_COLUMNS - bbox_w) / 2
	return ActivePiece.new(type, Constants.Rotation.SPAWN, Vector2i(column, 0))
