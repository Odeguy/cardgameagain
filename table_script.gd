extends Node2D
@export var card_scene: PackedScene

var hand = {}
var full_deck = {}
var deck
var screen_size
var area_size
var side_switched
var points
func _ready():
	points = 0
	deck = full_deck
	side_switched = false
	screen_size = get_viewport_rect().size
	$Area/Shape.shape.size = Vector2(screen_size.x, screen_size.y / 2 + screen_size.y / 36)
	area_size = $Area/Shape.shape.size
	$Area.position.x = screen_size.x / 2
	$Area.position.y = screen_size.y - $Area/Shape.shape.size.y * 0.5
	$Area/Points.set_position($Area/Shape.position - ($Area/Shape.shape.size / 2))
	$Area/Points.set_size(Vector2(area_size.x / 8, area_size.y / 12))
	
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
			hand[card].position.y = area_size.y * 4 / 3
		else:
			hand[card].position.x = screen_size.x - (start + increment * increments + hand[card].get_size().x / 2)
			hand[card].position.y = screen_size.y - area_size.y * 4 / 3
			print(hand[card].position)
		hand[card].rotation = $Area.rotation
		increments += 1
		hand[card].show()
		
func play_card(key: String) -> String:
	hand.erase(key)
	return key
	
	
func switch_side():
	side_switched = true
	$Area.rotate(3.14)
	$Area.position = Vector2($Area.position.x, ($Area/Shape.shape.size.y * 0.5))
		
