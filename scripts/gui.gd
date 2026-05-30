extends CanvasLayer

@onready var score: Label = $Container/MarginRight/RightPanel/GameInfo/Score
@onready var level: Label = $Container/MarginRight/RightPanel/GameInfo/Level
@onready var lines: Label = $Container/MarginRight/RightPanel/GameInfo/Lines
@onready var queue = $Container/MarginRight/RightPanel/Queue
@onready var _queue_previews: Array = [
	$Container/MarginRight/RightPanel/Queue/Control/TileMapLayer,
	$Container/MarginRight/RightPanel/Queue/Control2/TileMapLayer,
	$Container/MarginRight/RightPanel/Queue/Control3/TileMapLayer,
	$Container/MarginRight/RightPanel/Queue/Control4/TileMapLayer,
	$Container/MarginRight/RightPanel/Queue/Control5/TileMapLayer,
]

@onready var hold_piece = $Container/MarginLeft/LeftPanel/HoldPiece/TileMapLayer


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
	draw_preview(_hold_piece, tile_map)


func on_queue_changed(_queue: Array):
	for i in range(_queue_previews.size()):
		var tile_map: TileMapLayer = _queue_previews[i]
		var piece_type = _queue[i]
		draw_preview(piece_type, tile_map)


func draw_preview(piece_type: int, tile_map: TileMapLayer):
	tile_map.clear()
		
	var atlas = Constants.PIECE_ATLAS_COORDS[piece_type]
	
	# Need to offset tile_map so that the pieces are centered
	var queue_offset = Constants.PIECE_QUEUE_OFFSET[piece_type].x
	tile_map.position.x = queue_offset
	
	# Draw piece using tilemap atlas
	for cell_offset: Vector2i in Constants.PIECES[piece_type][Constants.Rotation.SPAWN]:
		tile_map.set_cell(cell_offset, 0, atlas)
