extends Area2D

@onready var player = $/root/World/TileMap/Player
@onready var information = $/root/World/UI/Information/Label

@export var destinations: Vector2

var player_inside = false

func _on_body_entered(body):
	if (body == player):
		player_inside = true
		information.show()
		information.text = 'Tekan [E] untuk masuk'

func _on_body_exited(body):
	if (body == player):
		player_inside = false
		information.hide()
		
func _input(event):
	if (Input.is_action_just_released('interact') and player_inside):
		player.global_position = destinations
