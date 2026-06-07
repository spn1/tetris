extends Node

@export var field: Field

@onready var line_clear: AudioStreamPlayer2D = $SFXLineClear
@onready var tetris_clear: AudioStreamPlayer2D = $SFXTetris

func _ready() -> void:
	field.lines_cleared.connect(_on_field_lines_cleared)


func _on_field_lines_cleared(count: int) ->  void:
	print("Count: ", count)
	if count < 4:
		line_clear.play()
	else:
		tetris_clear.play()
	
