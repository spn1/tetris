extends Node2D

# time between shifts down
@export var speed: float = 0.5

# Blocks
var blocks: Array[Block]
var active_block: Block

# Time
var time_since_last_drop: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active_block = get_node("ZBlock")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_time: int = Time.get_unix_time_from_system()
	if current_time - time_since_last_drop > speed:
		active_block.move_down()
		time_since_last_drop = current_time
