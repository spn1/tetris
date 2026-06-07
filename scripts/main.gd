extends Node2D

@onready var field: Field = $Field
@onready var gui = $GUI


func _ready() -> void:
	field.score_changed.connect(gui.on_score_changed)
	field.level_changed.connect(gui.on_level_changed)
	field.lines_cleared.connect(gui.on_lines_changed)
	field.hold_changed.connect(gui.on_hold_piece_changed)
	field.queue_changed.connect(gui.on_queue_changed)
	
	# _ready is run bottom-up, so child node _ready functions are run before this.
	# therefore, these signals are connected _after_ the board state is set
	sync_ui()

func sync_ui() -> void:
	gui.on_queue_changed(field.next_queue)
