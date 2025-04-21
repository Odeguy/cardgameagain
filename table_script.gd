extends Node2D
@export var card_scene: PackedScene

var hand = {}
var full_deck = {}
var deck
var screen_size
var area_size
var side_switched
var points
var maxx_p #when true, cards are drawn when points are reduced 
var peekable #number of turns cards can be peeked at for
var points_history = [] #tracks the peak of points since the start of the previous turn

func _ready():
	maxx_p = false
	peekable = 0 
	points_history = []
	points = 10
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
	points_history.append(points)
	
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
	return points
	
func change_card_points(key: String, num: int, type: String) -> void:
	if key == "Onyx Blade": return
	match type:
		"multiply": hand[key].set_points(hand[key].get_points() * num)
		"divide": hand[key].set_points(hand[key].get_points() / num)
		"add": hand[key].set_points(hand[key].get_points() + num)
		"subtract": hand[key].set_points(hand[key].get_points() - num)
		
func multiply_points(num: int):
	change_points(num, "multiply")

func divide_points(num: int):
	change_points(num, "divide")
	
func add_points(num: int):
	change_points(num, "add")
	
func subtract_points(num: int):
	change_points(num, "subtract")
	
func change_points(num: int, type: String):
	var initial_points = points
	match type:
		"multiply": points = points * num
		"divide": points = points / num
		"add": points = points + num
		"subtract": points = points - num
	refresh_points()
	if maxx_p: maxx_p_activate(initial_points, points)
	points_history.append(points)
	
func clear_points_history():
	points_history.clear()
	
func switch_side():
	side_switched = true
	$Area.rotate(3.14)
	$Area.position = Vector2($Area.position.x, ($Area/Shape.shape.size.y * 0.5))
	
#card effect functions
func block_peeking(turns: int) -> void:
	peekable = turns
		
func maxx_p_activate(before: int, after: int):
	maxx_p = true
	if before < after: draw_card()
	
func restore_points_to_peak():
	if !points_history.is_empty(): points = points_history.max()
	
