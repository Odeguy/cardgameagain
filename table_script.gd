extends Node2D
@export var card_scene: PackedScene

var hand = {}
var full_deck = {}
var deck = full_deck
var screen_size
func _ready():
	screen_size = get_viewport_rect().size
	$Area/Shape.shape.size = Vector2(screen_size.x, screen_size.y * 2 / 3)
	$Area.position.x = screen_size.x / 2
	$Area.position.y = screen_size.y / 3 + ($Area/Shape.shape.size.y * 0.5)
	
func add_to_deck(card):
	full_deck[card.card_name] = card
	card.hide()
	add_child(card)

func draw_card():
	if(deck.size() > 0):
		hand[deck.keys()[0]] = deck[deck.keys()[0]]
		deck[deck.keys()[0]].position = screen_size / Vector2(2, 2)
		deck.erase(deck.keys()[0])
		show_hand()
		
func show_hand():
	var start = screen_size / 5
	var increment = screen_size * 4 / 5 / hand.size()
	for card in hand:
		card.position = start + increment + card.get_size() / 2
		card.show()
	
func switch_side():
	pass
		
