extends Node2D
@export var table_scene: PackedScene
@export var card_scene: PackedScene

var cards = JSON.parse_string(FileAccess.get_file_as_string("res://cards.json"))
var player
var opponent
var turn = true #player's turn
var gameover
var chosen_card
var chosen_opponent_card
var points_goal
var text_break = 0.07
var turn_count 
var screen_size = get_viewport_rect().size

#initializes a new game
func _ready():
	screen_size = get_viewport_rect().size
	turn_count = 0
	points_goal = 500
	gameover = false
	load_goal()
	player = table_scene.instantiate()
	opponent = table_scene.instantiate()
	add_child(player)
	add_child(opponent)
	for i in range(14):
		player.add_to_deck(random_card())
		opponent.add_to_deck(random_card())
	opponent.switch_side()
	for i in range(7):
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
		await choose_card()
		var points = player.get_card_points(chosen_card)
		var card = player.play_card(chosen_card)
		await card_effect(card, points, player, opponent)
	else:
		if turn_count > 2:
			await get_tree().create_timer(0.5).timeout
			opponent.draw_card()
		await get_tree().create_timer(0.5).timeout
		var random_card = opponent.hand.get(randi() % opponent.hand.size())
		var points = opponent.get_card_points(random_card)
		var card = await opponent.play_card(random_card)
		await card_effect(card, points, opponent, player)
	if player.points == points_goal or opponent.points == points_goal:
		gameover = true
	if player.hand.size() == 0 and player.deck.size() == 0 or opponent.hand.size() == 0 and opponent.hand.size() == 0:
		gameover = true
	turn = !turn
	if !gameover:
		play()
		
func card_effect(card, points, sender, reciever):
	match card.get_card_name():
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
			await choose_card()
			if randi() % 10 > 6: sender.change_card_points(chosen_card, 2, "multiply")
			else: 
				player.play_card(chosen_card)
		"Divination":
			opponent.reveal_hand()
		"Vision Sharing":
			await choose_opponent_card()
			opponent.reveal_card(chosen_opponent_card)
		"Induction":
			print("Later")
		"Deduction":
			highlight_card(opponent.deck.get(0))
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
	
func text_prompt(prompt: String) -> Object: #returns the label so that it can be deleted
	var sign = RichTextLabel.new()
	sign.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sign.push_font_size(25)
	sign.append_text(prompt)
	sign.set_position(Vector2(screen_size.x / 5, screen_size.y * 5 / 6))
	sign.set_size(player.get_size())
	add_child(sign)
	return sign

func choose_card() -> Object:
	var prompt = text_prompt("Choose One Of Your Cards")
	chosen_card = null
	while chosen_card == null:
		await get_tree().process_frame
	prompt.queue_free()
	return chosen_card
	
func choose_opponent_card() -> Object:
	var prompt = text_prompt("Choose An Opponent Card")
	chosen_opponent_card = null
	while chosen_opponent_card == null:
		await get_tree().process_frame
	prompt.queue_free()
	return chosen_opponent_card

func duplicate_card(card: Object) -> Object:
	var new_card = card_scene.instantiate()
	new_card.card_name = card.card_name
	new_card.effect = card.effect
	new_card.points = card.points
	new_card.color = card.color
	new_card.font = card.font
	new_card.font_size = card.font_size
	return new_card
	
var highlight
var highlight_button
func highlight_card(card: Object) -> void:
	if card == null: return
	remove_child(highlight)
	remove_child(highlight_button)
	highlight = duplicate_card(card)
	highlight.switch_side("front")
	highlight.position = Vector2(highlight.get_size().x, player.get_hand_y())
	highlight_button = Button.new()
	highlight_button.text = "OK"
	highlight_button.position = Vector2(highlight.position.x - 15, highlight.position.y - highlight.get_size().y / 1.5)
	highlight_button.pressed.connect(_on_button_pressed.bind(highlight_button))
	add_child(highlight)
	add_child(highlight_button)
	highlight.show()
	highlight_button.show()
	while(highlight_button.text == "OK" and highlight != null):
		await get_tree().process_frame
	highlight.queue_free()
	highlight_button.queue_free()
	highlight = null
	highlight_button = null

func _on_button_pressed(button):
	if button.text == "OK": button.text = "COOL"

func new_turn() -> void: #everything that should happen at the beginning of a turn
	player.maxx_p = false
	opponent.maxx_p = false
	if player.peekable > 0: player.peekable -= 1
	if opponent.peekable > 0: opponent.peekable -= 1
	player.clear_points_history()
	opponent.clear_points_history()
		
func _input(event: InputEvent) -> void:
	for card in player.hand:
		if(event is InputEventMouseButton and event.pressed and card.loaded and card.has_point(get_global_mouse_position())):
			chosen_card = card
	for card in opponent.hand:
		if(event is InputEventMouseButton and event.pressed and card.loaded and card.has_point(get_global_mouse_position())):
			chosen_opponent_card = card
