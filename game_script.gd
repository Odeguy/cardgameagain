extends Node2D
@export var table_scene: PackedScene
@export var card_scene: PackedScene

var cards = JSON.parse_string(FileAccess.get_file_as_string("res://cards.json"))
var player
var opponent
var turn = true #player's turn
var gameover
var chosen_card
var points_goal
var text_break = 0.07
var turn_count 

#initializes a new game
func _ready():
	turn_count = 0
	points_goal = 500
	gameover = false
	load_goal()
	player = table_scene.instantiate()
	opponent = table_scene.instantiate()
	add_child(player)
	add_child(opponent)
	for i in range(50):
		player.add_to_deck(random_card())
		opponent.add_to_deck(random_card())
	opponent.switch_side()
	for i in range(5):
		player.draw_card()
		opponent.draw_card()
	player.show_hand()
	opponent.show_hand()
	play()
	
func load_goal():
	var goal_text = "Goal: " + str(points_goal)
	for char in goal_text:
		$Goal.append_text(char)
		await get_tree().create_timer(text_break).timeout

func create_card(num: int) -> Object:
	var new_card = card_scene.instantiate()
	new_card.set_card_name(cards["cards"][num]["name"])
	new_card.set_effect(cards["cards"][num]["effect"])
	new_card.set_points(cards["cards"][num]["points"])
	new_card.set_color(Color(0, 0, 0))
	new_card.set_font_size(50)
	return new_card

func random_card() -> Object:
	var new_card = card_scene.instantiate()
	var num = randi() % cards["cards"].size()
	new_card.set_card_name(cards["cards"][num]["name"])
	new_card.set_effect(cards["cards"][num]["effect"])
	new_card.set_points(cards["cards"][num]["points"])
	new_card.set_color(Color(0, 0, 0))
	new_card.set_font_size(50)
	return new_card

func play():
	new_turn()
	turn_count += 1
	if turn:
		if turn_count > 2: player.draw_card()
		chosen_card = null
		while chosen_card == null:
			await get_tree().process_frame
		var points = player.get_card_points(chosen_card)
		var card = player.play_card(chosen_card)
		card_effect(card, points, player, opponent)
	else:
		if turn_count > 2:
			await get_tree().create_timer(0.5).timeout
			opponent.draw_card()
		await get_tree().create_timer(0.5).timeout
		var random_card = opponent.hand.keys()[randi() % opponent.hand.size()]
		var points = opponent.get_card_points(random_card)
		var card = opponent.play_card(random_card)
		card_effect(card, points, opponent, player)
	if player.points == points_goal or opponent.points == points_goal: gameover = true
	if player.hand.size() == 0 or opponent.hand.size() == 0: gameover = true
	turn = !turn
	if !gameover:
		play()
		
func card_effect(card_name, points, sender, reciever):
	match card_name:
		"Hollow Mask":
			sender.block_peeking(points)
		"Pyrrhic Victory":
			sender.multiply_points(0)
			reciever.divide_points(points)
		"Monument to Pain":
			sender.maxx_p_activate(0, 0)
		"Onyx Blade":
			pass #passive in table_script change_card_points()
		"Restoring Flame":
			sender.restore_points_to_peak()
		"Reckless Gamble":
			pass
		"Divination":
			pass
		"Vision Sharing":
			pass
		"Induction":
			pass
		"Deduction":
			pass
		"Cause and Effect":
			pass
		"Free Will":
			pass
		"Calamity":
			pass
		"Luck Streak":
			pass
		"Motivational Poster":
			pass
		"Rousing Speech":
			pass
		"Sharp Outfit":
			pass
		"Cognitive Dissonance":
			pass
	sender.refresh_points()
	reciever.refresh_points()
	
func new_turn() -> void: #everything that should happen at the beginning of a turn
	player.maxx_p = false
	opponent.maxx_p = false
	if player.peekable > 0: player.peekable -= 1
	if opponent.peekable > 0: opponent.peekable -= 1
	player.clear_points_history()
	opponent.clear_points_history()
		
func _input(event: InputEvent) -> void:
	for card in player.hand:
		if(event is InputEventMouseButton and event.pressed and player.hand[card].loaded and player.hand[card].has_point(get_global_mouse_position())):
			chosen_card = card
