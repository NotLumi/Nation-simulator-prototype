extends Camera2D
class_name Camera

var targetZoom : float = 1.0

func _process(delta: float) -> void:
	zoom = lerp(zoom, targetZoom * Vector2.ONE, ZoomRate * delta)




func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position -= event.relative * zoom 


	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoomIn()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoomOut()
				
			fixZoom()
const ZoomRate : float = 8.0
const MaxZoom : float = 2.0
const MinZoom : float = 0.1
const ZoomIncrement : float = 0.1

func zoomIn() -> void:
	targetZoom += 0.25
	

func zoomOut() -> void:
	targetZoom -= 0.25
	
func fixZoom() -> void:
	if targetZoom < MinZoom:
		targetZoom = MinZoom
	if targetZoom > MaxZoom:
		targetZoom = MaxZoom
