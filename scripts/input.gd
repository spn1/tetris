extends Node

@onready var _board: Board = get_parent()

var _arr_acc: float = 0 # input action repeat accumulator
var _das_acc: float = 0 # repeat input delay accumulator

func _process(delta) -> void:
	if Input.is_action_pressed("move_left"):
		move_left(delta)
	elif Input.is_action_pressed("move_right"):
		move_right(delta)
	
	if Input.is_action_just_pressed("rotate_left"):
		rotate_left()
	elif Input.is_action_just_pressed("rotate_right"):
		rotate_right()
	
	if Input.is_action_just_pressed("soft_drop"):
		# TODO: Add auto-repeating soft drop
		soft_drop(delta)
	elif Input.is_action_just_pressed("sonic_drop"):
		sonic_drop()
	
	if Input.is_action_just_pressed("store_swap"):
		store_swap()

	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
		_das_acc = 0

func move_left(delta: float):
	if _das_acc == 0:
		_board.move_horizontal(delta, -1)

	_arr_acc += delta
	_das_acc += delta

	# If over DAS & ARR rates
	if _das_acc >= Constants.DAS_DELAY and _arr_acc >= Constants.ARR_RATE:
		_board.move_horizontal(delta, -1)
		_arr_acc = 0

func move_right(delta: float):
	if _das_acc == 0:
		_board.move_horizontal(delta, 1)

	_arr_acc += delta
	_das_acc += delta

	# If over DAS & ARR rates
	if _das_acc >= Constants.DAS_DELAY and _arr_acc >= Constants.ARR_RATE:
		_board.move_horizontal(delta, 1)
		_arr_acc = 0

func soft_drop(delta: float):
	_board.soft_drop(delta)

func sonic_drop():
	_board.sonic_drop()

func rotate_left():
	_board.try_rotate(-1)

func rotate_right():
	_board.try_rotate(1)

func store_swap():
	_board.do_hold()
