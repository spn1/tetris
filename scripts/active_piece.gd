class_name ActivePiece
extends RefCounted


var piece_type: Constants.Piece
var rotation: Constants.Rotation
var field_pos: Vector2i


func _init(type: Constants.Piece, _rotation: Constants.Rotation, pos: Vector2i) -> void:
	piece_type = type
	rotation = _rotation
	field_pos = pos


# Raw offsets for the piece's current rotation (local grid)
func cells() -> Array:
	return Constants.PIECES[piece_type][rotation]


# Global offsets for the piece in the real board
func world_cells() -> Array:
	var result: Array[Vector2i] = []
	for offset: Vector2i in cells():
		result.append(field_pos + offset)
		
	return result
