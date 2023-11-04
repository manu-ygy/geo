extends CharacterBody2D

@onready var dialog = $Dialog
@onready var label = $Dialog/DialogContainer/Padding/Label

var speed = 400  # speed in pixels/sec

func _ready():
	await get_tree().create_timer(1).timeout
	say('Sudah 5 tahun aku tidak berkunjung ke rumah nenek yang ada di pinggir pantai. Rasanya menyenangkan sekali.')

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

	move_and_slide()

func say(text):
	label.text = ''
	dialog.show()
	for letter in text:
		label.text += letter
		await get_tree().create_timer(0.05).timeout
		if (label.get_combined_minimum_size().x > 250):
			label.custom_minimum_size.x = 256
			label.autowrap_mode = 3
