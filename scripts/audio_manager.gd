extends Node

@export var field: Field

@onready var line_clear: AudioStreamPlayer2D = $SFXLineClear
@onready var tetris_clear: AudioStreamPlayer2D = $SFXTetris
@onready var piece_lock: AudioStreamPlayer2D = $SFXPieceLock
@onready var piece_drop: AudioStreamPlayer2D = $SFXPieceDrop

func _ready() -> void:
	field.lines_cleared.connect(_on_field_lines_cleared)
	field.piece_lock.connect(_on_field_piece_lock)
	field.piece_drop.connect(_on_field_piece_drop)


func _on_field_lines_cleared(count: int) ->  void:
	if count < 4:
		line_clear.play()
	else:
		tetris_clear.play()

func _on_field_piece_lock() -> void:
	piece_lock.play()

func _on_field_piece_drop() -> void:
	piece_drop.play()
