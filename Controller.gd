extends Node
const Grid = preload("res://Grid.gd")

enum GameState
{
	Idle,
	Busy
}

enum Direction
{
	Up,
	Down,
	Left, 
	Right
}

var State : GameState = GameState.Idle
var GridNode : Grid = null
@onready var RNG = RandomNumberGenerator.new()
var HighCellChance : float = 0.8

func _ready():
	get_tree().get_root().ready.connect(OnRootReady)
	
func OnRootReady():
	var root = get_tree().get_root()
	GridNode = root.get_node("Grid")
	GridNode.GridUpdated.connect(OnGridUpdated)
	
	# Begin start up sequence
	StartUp()

func OnGridUpdated():
	# Allow input again
	State = GameState.Idle
	
	# Spawn new tile
	AddNewCellInValidSpot()
	
	# Check if grid is full	
		# Check if there are any valid moves
			# if false, end game

func StartUp():
	RNG.randomize() # Seed the RNG for this game	
	
	# Reset grid
	GridNode.ClearGrid()
	
	# Add two random cells, either 2 or 4
	for i in range(0,2):
		AddNewCellInValidSpot()

func RandomGridCoords() -> Vector2i:
	# randi_range is inclusive	
	return Vector2i(RNG.randi_range(0, GridNode.GridXDim-1), RNG.randi_range(0, GridNode.GridYDim-1))

func AddNewCellInValidSpot():
	var xy = RandomGridCoords()
	while !GridNode.IsCellClear(xy):
		xy = RandomGridCoords()
	
	var value = 2 if RNG.randf() < HighCellChance else 4
	GridNode.SetGridCell(xy, value)

func _input(event):
	# ignore input events while busy
	if State == GameState.Busy:
		pass
	
	# Handle directional inputs	
	if event.is_action_pressed("ui_left"):
		HandleInput(Direction.Left)
	elif event.is_action_pressed("ui_right"):
		HandleInput(Direction.Right)
	elif event.is_action_pressed("ui_up"):
		HandleInput(Direction.Up)
	elif event.is_action_pressed("ui_down"):
		HandleInput(Direction.Down)
	
func HandleInput(direction: Direction):
	# Set as busy to block further input
	State = GameState.Busy
	
	# Tell grid to move in direction
	
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
