extends CanvasLayer

@onready var cursor = $Cursor

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(null)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_button_pressed():
	print('Home pressed')


func _process(delta):
	cursor.global_position = get_viewport().get_mouse_position()
