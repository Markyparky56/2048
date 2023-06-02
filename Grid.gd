extends Node2D

# if you want to make these tweakable you'll need to make the grid generated on init
const GridXDim = 4
const GridYDim = 4
const TilePrefab = preload("res://tile.tscn")
const Tile = preload("res://Tile.gd")
var GridBGNode : Node2D = null
var ActiveCellsNode : Node2D = null
var Grid = []

signal GridUpdated

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

func IsValidPos(xy: Vector2i) -> bool:
	if xy.y < 0 or xy.y > GridYDim-1:
		return false
	elif xy.x < 0 or xy.x > GridXDim-1:
		return false
	else:
		return true

func GetGridIdx(xy: Vector2i) -> int:
	return ((xy.y*GridXDim) + xy.x) if IsValidPos(xy) else -1

func GetGridPosition(xy: Vector2i) -> Vector2:
	var fmtString = "Slot{x}{y}"
	var slotName = fmtString.format({"x":xy.x, "y":xy.y})
	var gridSlot = GridBGNode.get_node(slotName)
	return gridSlot.position

func SetGridCell(xy: Vector2i, value: int):
	var cellIdx = GetGridIdx(xy)
	
	# Check if cell already exists at coords
	var cellInstance : Tile = Grid[cellIdx]
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
	
func IsGridFull() -> bool:
	for cell in Grid:
		if cell == null:
			return false
	return true
	
func GetCellValue(xy: Vector2i) -> int:
	var gridIdx = GetGridIdx(xy)
	if gridIdx != -1:
		var cell : Tile = Grid[gridIdx]
		if cell:
			return cell.Value	
	return 0

func CanTileMoveInto(desiredPos: Vector2i, cellValue: int) -> bool:
	return IsCellClear(desiredPos) or GetCellValue(desiredPos) == cellValue

func CanTileMoveUp(cell: Tile, pos: Vector2i) -> bool:
	var yMinus1 = pos - Vector2i(0,1)
	return CanTileMoveInto(yMinus1, cell.Value)
	
func CanTileMoveDown(cell: Tile, pos: Vector2i) -> bool:
	var yPlus1 	= pos + Vector2i(0,1)
	return CanTileMoveInto(yPlus1, cell.Value)
	
func CanTileMoveLeft(cell: Tile, pos: Vector2i) -> bool:
	var xMinus1 = pos - Vector2i(1,0)
	return CanTileMoveInto(xMinus1, cell.Value)
	
func CanTileMoveRight(cell: Tile, pos: Vector2i) -> bool:
	var xPlus1 	= pos + Vector2i(1,0)
	return CanTileMoveInto(xPlus1, cell.Value)
	
func CanTileMove(cell: Tile, pos: Vector2i) -> bool:
	return (CanTileMoveUp(cell, pos) 
		 or CanTileMoveDown(cell, pos) 
		 or CanTileMoveLeft(cell, pos) 
		 or CanTileMoveRight(cell, pos))

func AnyValidMoves() -> bool:
	# If there are empty spaces we can move
	if !IsGridFull():
		return true
	
	# Check for adjecent cells of the same value, 
	# if any, then there is still a valid move
	for y in range(0, GridYDim):
		for x in range(0, GridXDim):
			var cellPos = Vector2i(x, y)
			var cell = Grid[GetGridIdx(cellPos)]
			if CanTileMove(cell, cellPos):
				return true
				
	# else no valid moves found
	return false
