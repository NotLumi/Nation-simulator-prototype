extends Node2D

@onready var nationTilemapLayer: TileMapLayer = %NationTilemapLayer
@onready var evolutionTimer: Timer = %EvolutionTimer
@onready var simulateButton: Button = %SimulateButton
@onready var yearLabel: Label = %YearLabel
@onready var debugLabel: Label = %DebugLabel
@onready var fpsLabel: Label = %FPSLabel


var evolve : bool = false
var currentNationSelected : NationResource = Data.getNations()['blue']
var UIHovered : bool = false
var currentYear : int = 0

#region Data pools
var nationDictionary : Dictionary[Vector2i, NationResource] = {}

#endregion

func _ready() -> void:
	print(Data.getNations())

func _process(delta: float) -> void:
	fpsLabel.text = "FPS: %s" % [Engine.get_frames_per_second()]
	debugLabel.text = (
	"Tiles: %s" % [nationDictionary.keys().size()] + "\n" 
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


func evolveSimulation() -> void:
	for nationTile : Vector2i in nationDictionary:
		var dir = [
			nationTile + Vector2i.UP,
			nationTile + Vector2i.DOWN,
			nationTile + Vector2i.RIGHT,
			nationTile + Vector2i.LEFT,
		]
		
		var chosenTile : Vector2i = dir.pick_random()
		
		if !nationDictionary.has(chosenTile):
			spawnNationAt(dir.pick_random(), nationDictionary[nationTile])

	currentYear += 1
	yearLabel.text = "Year: %s" % [currentYear]
	

func _on_evolution_timer_timeout() -> void:
	var nations : Dictionary[String, NationResource] = Data.getNations() 
	evolveSimulation()
	
func _on_start_mouse_entered() -> void:
	UIHovered = true


func _on_start_mouse_exited() -> void:
	UIHovered = false


func _on_simulate_button_pressed() -> void:
	if evolve:
		evolutionTimer.stop()
		evolve = false
		simulateButton.text = "Start simulation"
	else:
		evolutionTimer.start()
		evolve = true
		simulateButton.text = "End simulation"
