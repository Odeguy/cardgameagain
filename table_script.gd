extends Node2D
@export var card_scene: PackedScene

var hand = {}
var full_deck = {}
var deck = full_deck
func _ready():
	$Area/Shape.shape.size = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y * 2 / 3)
	$Area.position.x = get_viewport_rect().size.x / 2
	$Area.position.y = get_viewport_rect().size.y / 3 + ($Area/Shape.shape.size.y * 0.5)
	
func add_to_deck(card):
	full_deck[card.card_name] = card
	card.hide()
	add_child(card)

func draw_card():
	if(deck.size() > 0):
		deck[deck.keys()[0]].show()
		deck.erase(deck.keys()[0])
		
