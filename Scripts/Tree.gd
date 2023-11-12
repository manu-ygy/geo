extends StaticBody2D

@onready var sprite = $Sprite
@onready var player = $/root/World/TileMap/Player
@onready var replant_dialog = $ReplantDialog
@onready var replant_label = $ReplantDialog/MarginContainer/Padding/Wrapper/Label
@onready var replant_button = $ReplantDialog/MarginContainer/Padding/Wrapper/Button
@onready var replant_progress = $ReplantDialog/MarginContainer/Padding/Wrapper/ProgressBar

var replanted = false
var is_replanting = true
var replant_price

func create_tree(size):
	sprite.frame = size
	
	if (size == 0):
		replant_label.text = 'Pohon bakau kecil'
		replant_price = 100
	else:
		replant_label.text = 'Pohon bakau besar'
		replant_price = 150
		
	replant_button.text = 'Tanam kembali (' + str(replant_price) + ' koin)'

func _on_player_detection_body_entered(body):
	if (body == player):
		replant_dialog.show()

func _on_player_detection_body_exited(body):
	if (body == player):
		replant_dialog.hide()

func _on_button_pressed():
	if (replant_price <= player.coin):
		player.coin -= replant_price
		
		sprite.frame = 2
		
		replant_button.hide()
		replant_progress.show()
		
		var tween = get_tree().create_tween()
		tween.tween_property(replant_progress, 'value', 100, 60)
		
		await tween.finished
		
		sprite.frame = 3
		
		replant_progress.hide()
