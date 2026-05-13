class_name Block
extends StaticBody2D


var is_active: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_active:
		return

	_handle_rotation()
	_handle_movement()


func _handle_rotation():
	if Input.is_action_just_pressed("rotate_left"):
		rotate_left()
	elif Input.is_action_just_pressed("rotate_right"):
		rotate_right()


func _handle_movement():
	if Input.is_action_just_pressed("move_left"):
		move_left()
	elif Input.is_action_just_pressed("move_right"):
		move_right()


func move_left():
	print("Moving Left")
	position.x -= Constants.GRID_INCREMENT


func move_right():
	print("Moving Right")
	position.x += Constants.GRID_INCREMENT


func move_down():
	print("Moving Down")
	position.y += Constants.GRID_INCREMENT


func rotate_left():
	print("Rotating Block Left")
	rotation +=  deg_to_rad(-90)

func rotate_right():
	print("Rotating Block Right")
	rotation += deg_to_rad(90)
