extends Node2D

@onready var nationTilemapLayer: TileMapLayer = %NationTilemapLayer
@onready var evolutionTimer: Timer = %EvolutionTimer
@onready var updateTimer: Timer = %UpdateTimer
@onready var simulateButton: Button = %SimulateButton
@onready var yearLabel: Label = %YearLabel
@onready var debugLabel: Label = %DebugLabel
@onready var fpsLabel: Label = %FPSLabel
@onready var activeTileTilemapLayer: TileMapLayer = %ActiveTileTilemapLayer


var evolve : bool = false
var currentNationSelected : NationResource = Data.getNations()['blue']
var UIHovered : bool = false
var currentYear : int = 0

#region Data pools
var nationDictionary : Dictionary[Vector2i, NationResource] = {}
var activeTilesDictionary : Dictionary[Vector2i, NationResource] # Tiles that are updateable
var activeTilemapArray : Array = []
#endregion

func _ready() -> void:
	print(Data.getNations())

func _process(delta: float) -> void:
	#
	#for i in activeTilemapArray:
		#activeTilemapArray.erase(i)
		#activeTileTilemapLayer.erase_cell(i)
	#for i in activeTilesDictionary:
		#activeTileTilemapLayer.set_cell(i, 0, Vector2i.ZERO)
		#if i not in activeTilemapArray:
			#activeTilemapArray.append(i)
	
	
	
	fpsLabel.text = "FPS: %s" % [Engine.get_frames_per_second()]
	debugLabel.text = (
	"Tiles: %s" % [nationDictionary.keys().size()] + "\n" +
	"Active tiles: %s" % [activeTilesDictionary.size()]
	)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawnNation") and !UIHovered:
		spawnNation(currentNationSelected)

func spawnNation(nation : NationResource) -> void:
	var pos = nationTilemapLayer.local_to_map(get_global_mouse_position())
	nationTilemapLayer.set_cell(pos, 0, nation.atlas)
	nationDictionary[pos] = nation
	
func spawnNationAt(pos : Vector2i, nation : NationResource) -> void:
	nationTilemapLayer.set_cell(pos, 0, nation.atlas)
	nationDictionary[pos] = nation

func updateActiveTiles() -> void:
	activeTilesDictionary.clear()
	
	for tile in nationDictionary:
	
		var emptySurroundingTileArray = getAvailableSurroundingTiles(tile)
	
		if emptySurroundingTileArray.size() > 0: # if there is a surrounding tile
			if !activeTilesDictionary.has(tile): # and surrounding tile not in active
				activeTilesDictionary[tile] = nationDictionary[tile]
				
		else:
			activeTilesDictionary.erase(tile)

func evolveSimulation() -> void:

	for i in activeTilesDictionary:
		if getAvailableSurroundingTiles(i).size() > 0:
			if randi() % 2:
				var emptyTile : Vector2i = getAvailableSurroundingTiles(i).pick_random()
				spawnNationAt(emptyTile, activeTilesDictionary[i])
		
	currentYear += 1
	yearLabel.text = "Year: %s" % [currentYear]
	
func getAvailableSurroundingTiles(tile : Vector2i) -> Array:
	var newArray : Array[Vector2i] = []
	
	var dir = [
				tile + Vector2i.UP,
				tile + Vector2i.DOWN,
				tile + Vector2i.RIGHT,
				tile + Vector2i.LEFT,
					]
					
	for i in dir:
		if !nationDictionary.has(i):
			newArray.append(i)
	return newArray

func _on_evolution_timer_timeout() -> void:
	var nations : Dictionary[String, NationResource] = Data.getNations() 
	evolveSimulation()
	
func _on_update_timer_timeout() -> void:
	updateActiveTiles()


func _on_start_mouse_entered() -> void:
	UIHovered = true


func _on_start_mouse_exited() -> void:
	UIHovered = false


func _on_simulate_button_pressed() -> void:
	if evolve:
		evolutionTimer.stop()
		updateTimer.stop()
		evolve = false
		simulateButton.text = "Start simulation"
	else:
		evolutionTimer.start()
		updateTimer.start()
		evolve = true
		simulateButton.text = "End simulation"
