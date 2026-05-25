extends Node2D

@onready var board: Board = $Board
@onready var gui = $GUI


func _ready() -> void:
	board.score_changed.connect(gui.on_score_changed)
	board.level_changed.connect(gui.on_level_changed)
	board.lines_cleared.connect(gui.on_lines_changed)
	board.hold_changed.connect(gui.on_hold_piece_changed)
	board.queue_changed.connect(gui.on_queue_changed)
	
	# _ready is run bottom-up, so child node _ready functions are run before this.
	# therefore, these signals are connected _after_ the board state is set
	sync_ui()

func sync_ui() -> void:
	gui.on_queue_changed(board.next_queue)
