extends TileMap

var tree_instance = load('res://tree.tscn')
var trash_instance = load('res://trash.tscn')

@onready var spawnable_locations = get_used_cells(6)
var used_locations = []

var trash_list = ['Ranting', 'Kantung plastik', 'Bungkus makanan', 'Botol plastik', 'Kaleng', 'Botol kaca', 'Ban', 'Baju', 'Kayu', 'Jaring']
var trash_price = [3, 3, 5, 5, 5, 7, 10, 15, 15, 30]

# Called when the node enters the scene tree for the first time.
func _ready():
	# rendering trees
	
	var cells = get_used_cells(5)
	for cell in cells:
		var tree = tree_instance.instantiate()
		add_child(tree)
		
		tree.position = map_to_local(cell) + Vector2(0, 48)
		tree.create_tree(get_cell_tile_data(5, cell).z_index - 10)
		
	spawn_trash()
	
func spawn_trash():
	var spawn_location
	if (used_locations.size() < spawnable_locations.size()):
		while (spawn_location in used_locations or !spawn_location):
			spawn_location = spawnable_locations[randi() % spawnable_locations.size()]
		
		used_locations.append(spawn_location)
		
		var trash = trash_instance.instantiate()
		var trash_index = randi() % trash_list.size()
		trash.trash_name = trash_list[trash_index]
		trash.spawn_location = spawn_location
		add_child(trash)
		trash.sprite.frame = trash_index
		
		trash.position = map_to_local(spawn_location)
	
	await get_tree().create_timer(1).timeout
	
	spawn_trash()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
