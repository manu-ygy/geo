extends StaticBody2D

@onready var sprite = $Sprite
@onready var player = $/root/World/TileMap/Player
@onready var replant_dialog = $ReplantDialog
@onready var replant_label = $ReplantDialog/MarginContainer/Padding/Wrapper/Label

var replanted = false

func create_tree(size):
	sprite.frame = size
	
	if (size == 0):
		replant_label.text = 'Pohon bakau kecil'
	else:
		replant_label.text = 'Pohon bakau besar'

func _on_player_detection_body_entered(body):
	if (body == player):
		if (replanted == false):
			replant_dialog.show()

func _on_player_detection_body_exited(body):
	if (body == player):
		replant_dialog.hide()

func _on_button_pressed():
	sprite.frame = 2
	replanted = true
