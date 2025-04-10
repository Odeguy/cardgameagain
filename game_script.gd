extends Node2D
@export var table_scene: PackedScene
@export var card_scene: PackedScene

var cards = JSON.parse_string(FileAccess.get_file_as_string("res://cards.json"))
var player
var opponent
var turn = true #player's turn
var gameover

func _ready():
	gameover = false
	player = table_scene.instantiate()
	player.add_to_deck(create_card(1))
	opponent = table_scene.instantiate()
	opponent.switch_side()
	opponent.add_to_deck(create_card(0))
	add_child(player)
	add_child(opponent)
	for i in range(5):
		player.draw_card()
		opponent.draw_card()
	#play()
	
func create_card(num):
	var new_card = card_scene.instantiate()
	new_card.set_card_name(cards["cards"][num]["name"])
	new_card.set_effect(cards["cards"][num]["effect"])
	new_card.set_color(Color(0, 0, 0))
	new_card.set_font_size(5)
	return new_card

func play():
	if turn:
		pass
	else:
		pass
	if !gameover:
		play()
