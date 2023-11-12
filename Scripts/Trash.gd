extends StaticBody2D

signal taken

@onready var player = $/root/World/TileMap/Player
var player_inside = false

var spawn_location
var trash_name = ''

var added = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	if (global_position.y > 528):
		global_position.y -= 10
	else:
		set_process(false)
		
func _on_pickup_area_body_entered(body):
	if (body == player):
		player_inside = true

func _on_pickup_area_body_exited(body):
	if (body == player):
		player_inside = false
		
func _input(event):
	if (Input.is_action_just_released('interact') and player_inside and added == false):
		added = true
		if (player.add_to_inventory(trash_name)):
			get_parent().used_locations.erase(spawn_location)
			queue_free()
		else:
			added = false
