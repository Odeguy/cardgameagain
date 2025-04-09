extends Node2D
@export var table_scene: PackedScene
@export var card_scene: PackedScene

var cards = JSON.parse_string(FileAccess.get_file_as_string("res://cards.json"))
var player

func _ready():
	player = table_scene.instantiate()
	player.add_to_deck(create_card(1))
	add_child(player)
	player.draw_card()
	
func create_card(num):
	var new_card = card_scene.instantiate()
	new_card.set_card_name(cards["cards"][num]["name"])
	new_card.set_effect(cards["cards"][num]["effect"])
	new_card.set_color(Color(0, 0, 0))
	new_card.set_font_size(5)
	return new_card
	
