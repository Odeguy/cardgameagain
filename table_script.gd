extends Node2D
@export var card_scene: PackedScene

var hand = {}
var full_deck = {}
var deck = full_deck
var screen_size
var area_size
var side_switched = false
func _ready():
	side_switched = false
	screen_size = get_viewport_rect().size
	$Area/Shape.shape.size = Vector2(screen_size.x, screen_size.y * 2 / 3)
	area_size = $Area/Shape.shape.size
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
		
func show_hand():
	var start = area_size.x / 5
	var increment = area_size.x * 4 / 5 / (hand.size() + 1)
	var increments = 1
	for card in hand:
		if(!side_switched):
			hand[card].position.x = start + increment * increments + hand[card].get_size().x / 2
			hand[card].position.y = area_size.y * 8 / 7
		else:
			hand[card].position.x = screen_size.x - (start + increment * increments + hand[card].get_size().x / 2)
			hand[card].position.y = screen_size.y - area_size.y * 8 / 7
			print(hand[card].position)
		hand[card].rotation = $Area.rotation
		increments += 1
		hand[card].show()
	
func switch_side():
	side_switched = true
	$Area.rotate(3.14)
	$Area.position = Vector2($Area.position.x, ($Area/Shape.shape.size.y * 0.5))
		
