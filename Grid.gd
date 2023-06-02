extends Node2D

# if you want to make these tweakable you'll need to make the grid generated on init
const GridXDim = 4
const GridYDim = 4
const TilePrefab = preload("res://tile.tscn")
var GridBGNode : Node2D = null
var ActiveCellsNode : Node2D = null
var Grid = []

func _ready():
	# Get background and active cells nodes
	GridBGNode = get_node("GridBackground")
	ActiveCellsNode = get_node("ActiveCells")
	
	ClearGrid()	
	
func ClearGrid():
	# Fill grid with empty cells
	for y in range(0,GridYDim):
		for x in range(0,GridXDim):
			Grid.append(null)
			
	# Make sure there are no Active Cells present
	var activeCells = ActiveCellsNode.get_children()
	for cell in activeCells:
		ActiveCellsNode.remove_child(cell)
		cell.queue_free()

func GetGridIdx(xy: Vector2i) -> int:
	return (xy.y*GridXDim) + xy.x

func GetGridPosition(xy: Vector2i) -> Vector2:
	var fmtString = "Slot{x}{y}"
	var slotName = fmtString.format({"x":xy.x, "y":xy.y})
	var gridSlot = GridBGNode.get_node(slotName)
	return gridSlot.position

func SetGridCell(xy: Vector2i, value: int):
	var cellIdx = GetGridIdx(xy)
	
	# Check if cell already exists at coords
	var cellInstance = Grid[cellIdx]
	if cellInstance == null:
		# Make new cell
		cellInstance = TilePrefab.instantiate()
		Grid[cellIdx] = cellInstance
		ActiveCellsNode.add_child(cellInstance)
		cellInstance.position = GetGridPosition(xy)
	
	# Set cell's value
	cellInstance.SetValue(value)
	
func IsCellClear(xy: Vector2i) -> bool:
	return Grid[GetGridIdx(xy)] == null
