extends CanvasLayer

@onready var score: Label = $Container/RightPanel/GameInfo/Score
@onready var level: Label = $Container/RightPanel/GameInfo/Level
@onready var lines: Label = $Container/RightPanel/GameInfo/Lines
@onready var queue = $Container/RightPanel/Queue

@onready var hold_piece: Label = $Container/LeftPanel/HoldPiece


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
	hold_piece.text = str(_hold_piece)


func on_queue_changed(_queue: Array):
	var labels = queue.get_children()
	for i in range(labels.size()):
		var piece_type = _queue[i]
		var piece = Constants.Piece.keys()[piece_type]
		labels[i].text = Constants.Piece.keys()[_queue[i]]
