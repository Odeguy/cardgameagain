extends Node2D
@export var table_scene: PackedScene
@export var card_scene: PackedScene

var cards = JSON.parse_string(FileAccess.get_file_as_string("res://cards.json"))
var player
var opponent
var turn = true #player's turn
var gameover
var chosen_card

func _ready():
	gameover = false
	player = table_scene.instantiate()
	opponent = table_scene.instantiate()
	add_child(player)
	add_child(opponent)
	for i in range(5):
		player.add_to_deck(create_card(i))
		opponent.add_to_deck(create_card(i))
	opponent.switch_side()
	for i in range(5):
		player.draw_card()
		opponent.draw_card()
	player.show_hand()
	opponent.show_hand()
	play()
	
func create_card(num: int) -> Object:
	var new_card = card_scene.instantiate()
	new_card.set_card_name(cards["cards"][num]["name"])
	new_card.set_effect(cards["cards"][num]["effect"])
	new_card.set_color(Color(0, 0, 0))
	new_card.set_font_size(5)
	return new_card

func play():
	if turn:
		chosen_card = null
		while chosen_card == null:
			await get_tree().process_frame
	else:
		gameover = true
	if !gameover:
		play()
		
func _input(event: InputEvent) -> void:
	for card in player.hand:
		if(event is InputEventMouseButton and event.pressed and player.hand[card].has_point(get_global_mouse_position())):
			chosen_card = card
