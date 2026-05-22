class_name Board
extends Node2D

@onready var _locked_cells: TileMapLayer = $LockedCells
@onready var _active_tiles: TileMapLayer = $ActivePieceTiles
@onready var _ghost_tiles: TileMapLayer = $GhostTiles

var _drop_acc: float = 0.0 # time since last gravity tick
var _lock_acc: float = -1.0 # -1 = not in lock delay
var _arr_acc: float = 0 # input action repeat accumulator
var _das_acc: float = 0 # repeat input delay accumulator

# The board (rows added later) - 0 if empty, 1-7 = piece
# `grid` is a list of rows. I.e. grid[x][y]
var grid: Array = [] 

var active_piece: ActivePiece
var next_queue: Array = []
var _bag: Array = []

var hold_piece: int = -1 #  empty if -1
var hold_used: bool = false

var score: int = 0 # Total Score
var level: int = 10
var lines: int = 0 # Amount of lines cleared
var _back_to_back: bool = false # Was last clear a tetris?

# Signals
signal score_changed(new_score: int)
signal level_changed(new_level: int)
signal lines_cleared(count: int)
signal queue_changed(queue: Array)
signal hold_changed(hold_piece: int)
signal game_over()

func _log_grid() -> void:
	print("================================")
	for row in grid:
		print(row)


func _ready() -> void:
	_init_grid()
	_refill_queue()
	_spawn_next_piece()

func _process(delta: float) -> void:
	if active_piece == null:
		return
	_handle_input(delta)
	_tick_gravity(delta)
	_redraw()

func _handle_input(delta) -> void:
	if Input.is_action_pressed("move_left"):
		move_horizontal(delta, -1)
	elif Input.is_action_pressed("move_right"):
		move_horizontal(delta, 1)
	
	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
		_das_acc = 0


func move_horizontal(delta: float, direction: int) -> void:
	var valid_movement := is_valid_position(
		active_piece.piece_type,
		active_piece.rotation,
		active_piece.grid_pos + Vector2i(direction, 0)
	)
	
	if valid_movement:
		# Move piece once before preventing auto shift
		if _das_acc == 0:
			active_piece.grid_pos.x += direction

		_arr_acc += delta
		_das_acc += delta
		
		# If over DAS & ARR rates
		if _das_acc >= Constants.DAS_DELAY and _arr_acc >= Constants.ARR_RATE:
			active_piece.grid_pos.x += direction
			_arr_acc = 0

func _tick_gravity(delta: float) -> void:
	var on_floor := not is_valid_position(
		active_piece.piece_type,
		active_piece.rotation,
		active_piece.grid_pos + Vector2i(0,1)
	)
	
	# Start timer to lock piece
	if on_floor:
		if _lock_acc == -1:
			_lock_acc = 0

		_lock_acc += delta
		if _lock_acc >= Constants.LOCK_DELAY:
			lock_active_piece()
			_lock_acc = -1
			_drop_acc = 0
		
	# Start timer to drop piece
	else:
		_lock_acc = -1.
		_drop_acc += delta
		if _drop_acc >= drop_interval():
			active_piece.grid_pos.y += 1
			_drop_acc = 0

func _redraw() -> void:
	_redraw_locked()
	_redraw_active()
	_redraw_ghost()

func _redraw_locked() -> void:
	_locked_cells.clear()
	for row in range(Constants.BOARD_ROWS):
		for col in range(Constants.BOARD_COLUMNS):
			var colour = grid[row][col]
			if colour != 0:
				var atlas := Constants.PIECE_ATLAS_COORDS[colour - 1]
				_locked_cells.set_cell(Vector2i(col, row), 0, atlas)

func _redraw_active() -> void:
	_active_tiles.clear()
	if active_piece == null:
		return
	var atlas = Constants.PIECE_ATLAS_COORDS[active_piece.piece_type]
	for cell: Vector2i in active_piece.world_cells():
		if cell.y >= 0:
			_active_tiles.set_cell(cell, 0, atlas)

func _redraw_ghost() -> void:
	_ghost_tiles.clear()
	if active_piece == null:
		return

	var ghost_pos = active_piece.grid_pos
	while is_valid_position(active_piece.piece_type, active_piece.rotation, ghost_pos + Vector2i(0, 1)):
		ghost_pos.y += 1
	
	if ghost_pos == active_piece.grid_pos:
		return
	
	var atlas = Constants.PIECE_ATLAS_COORDS[active_piece.piece_type]
	for offset: Vector2i in Constants.PIECES[active_piece.piece_type][active_piece.rotation]:
		var cell = ghost_pos + offset
		if cell.y >= 0:
			_ghost_tiles.set_cell(cell, 0, atlas)

func _init_grid() -> void:
	grid = []
	for _r in range(Constants.BOARD_ROWS):
		var row: Array[int] = []
		row.resize(Constants.BOARD_COLUMNS)
		row.fill(0)
		grid.append(row)


# Checks if the placement of the specified piece at the given
# rotation and position is a valid position
func is_valid_position(
	type: Constants.Piece,
	rot: Constants.Rotation,
	pos: Vector2i
) -> bool:
	for offset: Vector2i in Constants.PIECES[type][rot]:
		var cell := pos + offset
		if cell.x < 0 or cell.x >= Constants.BOARD_COLUMNS:
			return false
		if cell.y >= Constants.BOARD_ROWS:
			return false
		if cell.y >= 0 and grid[cell.y][cell.x] != 0:
			return false
	return true


func clear_lines() -> int:
	var cleared := 0
	var row = Constants.BOARD_ROWS - 1
	# Iterate through rows from the bottom
	while row >= 0:
		if _is_row_full(row):
			_remove_row(row)
			cleared += 1
		else:
			row -= 1
	return cleared


func _is_row_full(row: int) -> bool:
	for col in range(Constants.BOARD_COLUMNS):
		if grid[row][col] == 0:
			return false
	return true


func _remove_row(row: int) -> void:
	grid.remove_at(row)
	var empty_row: Array[int] = []
	empty_row.resize(Constants.BOARD_COLUMNS)
	empty_row.fill(0)
	grid.insert(0, empty_row)


func calculate_line_score(cleared: int) -> int:
	const BASE: Array[int] = [0, 100, 300, 500, 800]
	var pts: int = BASE[cleared] * level

	if cleared == 4 and _back_to_back:
		pts = 1200 * level

	return pts


func _apply_line_clear(cleared: int) -> void:
	if cleared == 0:
		return
	score += calculate_line_score(cleared)
	_back_to_back = (cleared == 4)
	lines += cleared

	var new_level := 1 + lines / 10
	if new_level != level:
		level = new_level
		level_changed.emit(level)

	score_changed.emit(score)
	lines_cleared.emit(cleared)

# Calculate drop interval based on current level
func drop_interval() -> float:
	return pow(0.8 - (level - 1) * 0.007, level - 1)


func _refill_queue() -> void:
	while next_queue.size() < 5:
		if _bag.is_empty():
			_bag = PieceFactory.new_bag()
		next_queue.append(_bag.pop_front())
	queue_changed.emit(next_queue.duplicate())

# Returns the next piece from the queue
func _draw_from_queue() -> Constants.Piece:
	var type: Constants.Piece = next_queue.pop_front()
	_refill_queue()
	return type

# Spawns a new piece at the top of the board
# If the new piece is immediately not valid, the game is over
func _spawn_next_piece() -> void:
	var type = _draw_from_queue()
	active_piece = PieceFactory.spawn_piece(type)
	hold_used = false
	if not is_valid_position(active_piece.piece_type, active_piece.rotation, active_piece.grid_pos):
		game_over.emit()

# Locks the active piece after landing
func lock_active_piece() -> void:
	print("Locking Active Piece - ", active_piece.piece_type)
	for cell: Vector2i in active_piece.world_cells():
		print("\t", cell)
		if cell.y >= 0:
			grid[cell.y][cell.x] = active_piece.piece_type + 1
		var cleared := clear_lines()
		_apply_line_clear(cleared)
	
	_spawn_next_piece()
	_log_grid()
