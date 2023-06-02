extends Node2D

var Grid = []
var GridXDim = 4
var GridYDim = 4
var TilePrefab = preload("res://tile.tscn")
var GridBGNode = null
var ActiveCellsNode = null

func _ready():
	# Fill grid with empty cells
	for y in range(0,GridYDim):
		for x in range(0,GridXDim):
			Grid.append(null)
	
	# Get background and active cells nodes
	GridBGNode = get_node("GridBackground")
	ActiveCellsNode = get_node("ActiveCells")
	
	SetGridCell(3,3, 4)
	

func GetGridIdx(x : int, y : int) -> int:
	return (y*GridXDim) + x

func GetGridPosition(x : int, y : int) -> Vector2:
	var fmtString = "Slot{x}{y}"
	var slotName = fmtString.format({"x":x, "y":y})
	var gridSlot = GridBGNode.get_node(slotName)
	return gridSlot.position

func SetGridCell(x: int, y: int, value: int):
	var cellIdx = GetGridIdx(x, y)
	
	# Check if cell already exists at coords
	var cellInstance = Grid[cellIdx]
	if cellInstance == null:
		# Make new cell
		cellInstance = TilePrefab.instantiate()
		Grid[cellIdx] = cellInstance
		ActiveCellsNode.add_child(cellInstance)
		cellInstance.position = GetGridPosition(x, y)
	
	# Set cell's value
	cellInstance.SetValue(value)
	

