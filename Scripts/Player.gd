extends CharacterBody2D

signal clicked

@onready var dialog = $Dialog
@onready var label = $Dialog/DialogContainer/Padding/Label

@onready var state_machine = $AnimationTree.get('parameters/playback')
@onready var animation = $AnimationTree

@onready var coin_label = $/root/World/UI/Stats/Wrapper/Wrapper/Coin/Container/Label

@onready var inventory_progress = $/root/World/UI/Stats/Wrapper/Wrapper/Inventory/ProgressBar
@onready var inventory_progress_label = $/root/World/UI/Stats/Wrapper/Wrapper/Inventory/Label

@onready var trade_window = $/root/World/UI/TradeWindow
@onready var trash_name = $/root/World/UI/TradeWindow/Container/Wrapper/Wrapper/TrashName
@onready var trash_count = $/root/World/UI/TradeWindow/Container/Wrapper/Wrapper/TrashCount

var inventory_size = 20
var inventory = []

var speed = 300  # speed in pixels/sec
var wait_for_click = false
var is_typing = false

var trash_list = ['Ranting', 'Kantung plastik', 'Bungkus makanan', 'Botol plastik', 'Kaleng', 'Botol kaca', 'Ban', 'Baju', 'Kayu', 'Jaring']
var trash_price = [3, 3, 5, 5, 5, 7, 10, 15, 15, 30]

var coin = 0: set = update_coin

func _ready():
	await say('Test dialog')
	await say('Test dialog yang puanjangggggggggggggggggggggggggggggggggggggggggggggg banget')
	
func _input(event):
	if ((event is InputEventMouseButton and event.pressed) or Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE)):
		if (is_typing):
			is_typing = false
		
		if (wait_for_click):
			emit_signal('clicked')

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	
	if (velocity != Vector2.ZERO):
		animation.set('parameters/walk/blend_position', direction)
		animation.set('parameters/idle/blend_position', direction)
		
		state_machine.travel('walk')
	else:
		state_machine.travel('idle')

	move_and_slide()

func say(text):
	label.text = ''
	label.custom_minimum_size.x = 0
	label.autowrap_mode = 0

	dialog.show()
	is_typing = true
	for letter in text:
		if (is_typing):
			label.text += letter
			await get_tree().create_timer(0.05).timeout
		else:
			label.text = text
		
		if (label.get_combined_minimum_size().x > 250):
			label.custom_minimum_size.x = 256
			label.autowrap_mode = 3
	
	is_typing = false
	wait_for_click = true
	
	await clicked
	dialog.hide()

func add_to_inventory(item):
	if (inventory.size() < inventory_size):
		inventory.append(item)
		inventory_progress.value = inventory.size()
		inventory_progress_label.text = str(inventory.size()) + '/' + str(inventory_size)
		
		return true
	else:
		calculate_trash()
		return false

func calculate_trash():
	var calculated_trash_count = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	for trash in inventory:
		calculated_trash_count[trash_list.find(trash)] += 1
		
	var x = 0
	
	trash_name.text = ''
	trash_count.text = ''
	
	var total = 0
	for trash in calculated_trash_count:
		if (trash != 0):
			var converted = trash * trash_price[x]
			trash_name.text += trash_list[x] + ' (' + str(trash) + 'x)' + '\n'
			trash_count.text += str(converted) + ' koin\n'
			total += converted
		x += 1
		
	trash_name.text += 'Total'
	trash_count.text += str(total) + ' koin\n'
		
	trade_window.show()
	
	inventory = []
	inventory_progress.value = 0
	inventory_progress_label.text = '0/' + str(inventory_size)
	
	coin += total

func update_coin(value):
	coin = value
	coin_label.text = 'Koin: ' + str(value)

func _on_button_pressed():
	trade_window.hide()
