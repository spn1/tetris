extends CanvasLayer

@onready var score: Label = $Container/RightPanel/GameInfo/Score
@onready var level: Label = $Container/RightPanel/GameInfo/Level
@onready var lines: Label = $Container/RightPanel/GameInfo/Lines
@onready var queue = $Container/RightPanel/Queue
@onready var _queue_previews: Array = [
	$Container/RightPanel/Queue/Control/TileMapLayer,
	$Container/RightPanel/Queue/Control2/TileMapLayer,
	$Container/RightPanel/Queue/Control3/TileMapLayer,
	$Container/RightPanel/Queue/Control4/TileMapLayer,
	$Container/RightPanel/Queue/Control5/TileMapLayer,
]

@onready var hold_piece = $Container/LeftPanel/HoldPiece/TileMapLayer


### ===============================
# Signal Handlers
### ===============================
func on_score_changed(_score: int) -> void:
	score.text = str(_score)


func on_level_changed(_level: int) -> void:
	level.text = str(_level)


func on_lines_changed(_lines: int) -> void:
	lines.text = str(_lines)


func on_hold_piece_changed(_hold_piece: int) -> void:
	var tile_map: TileMapLayer = hold_piece
	tile_map.clear()

	var atlas = Constants.PIECE_ATLAS_COORDS[_hold_piece]
	for offset: Vector2i in Constants.PIECES[_hold_piece][Constants.Rotation.SPAWN]:
		tile_map.set_cell(offset, 0, atlas)


func on_queue_changed(_queue: Array):
	for i in range(_queue_previews.size()):
		var tile_map: TileMapLayer = _queue_previews[i]
		tile_map.clear()

		var piece_type = _queue[i]
		var atlas = Constants.PIECE_ATLAS_COORDS[piece_type]
		for offset: Vector2i in Constants.PIECES[piece_type][Constants.Rotation.SPAWN]:
			tile_map.set_cell(offset, 0, atlas)
