extends Node2D
@export var card_scene: PackedScene

var hand = {}
var full_deck = {}
var deck
var screen_size
var area_size
var side_switched
var points
var peekable #number of turns cards can be peeked at for

func _ready():
	peekable = 0 
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
	refresh_points()
	
func add_to_deck(card):
	full_deck[card.card_name] = card
	card.hide()
	add_child(card)

func draw_card():
	if(deck.size() > 0):
		hand.set(deck.keys()[0], deck.get(deck.keys()[0]))
		deck[deck.keys()[0]].position = screen_size / Vector2(2, 2)
		deck.erase(deck.keys()[0])
		show_hand()
		
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
		hand[card].rotation = $Area.rotation
		increments += 1
		hand[card].show()

func refresh_points():
	$Area/Points.clear()
	$Area/Points.append_text(str(points))
		
func play_card(key: String) -> String:
	var name = hand[key].get_card_name()
	remove_child(hand[key])
	hand.erase(key)
	show_hand()
	refresh_points()
	return name
	
func get_card_points(key: String) -> int:
	var points = hand[key].get_points()
	refresh_points()
	return points
	
func change_card_points(key: String, num: int, type: String) -> void:
	if key == "Onyx Blade": return
	match type:
		"multiply": hand[key].set_points(hand[key].get_points() * num)
		"divide": hand[key].set_points(hand[key].get_points() / num)
		"add": hand[key].set_points(hand[key].get_points() + num)
		"subtract": hand[key].set_points(hand[key].get_points() - num)
	
func switch_side():
	side_switched = true
	$Area.rotate(3.14)
	$Area.position = Vector2($Area.position.x, ($Area/Shape.shape.size.y * 0.5))
	
#card effect functions
func new_turn() -> void: #everything that should happen at the beginning of a turn
	if peekable > 0: peekable -= 1
	
func block_peeking(turns: int) -> void:
	peekable = turns
		
