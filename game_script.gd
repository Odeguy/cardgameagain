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

#initializes a new game
func _ready():
	points_goal = 500
	gameover = false
	load_goal()
	player = table_scene.instantiate()
	opponent = table_scene.instantiate()
	add_child(player)
	add_child(opponent)
	for i in range(5): #adds the first 5 cards in the card json to both decks
		player.add_to_deck(create_card(i))
		opponent.add_to_deck(create_card(i))
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
	new_card.set_color(Color(0, 0, 0))
	new_card.set_font_size(5)
	return new_card

func play():
	if turn:
		chosen_card = null
		while chosen_card == null:
			await get_tree().process_frame
		card_effect(player.play_card(chosen_card), player, opponent)
	else:
		await get_tree().create_timer(0.5).timeout
		var random_card = opponent.hand.keys()[randi() % opponent.hand.size()]
		card_effect(opponent.play_card(random_card), opponent, player)
	if player.points == 5 or opponent.points == 5: gameover = true
	turn = !turn
	if !gameover:
		play()
		
func card_effect(effect, sender, reciever):
	if effect == "None":
		sender.points += 1
	sender.refresh_points()
	reciever.refresh_points()
	
		
func _input(event: InputEvent) -> void:
	for card in player.hand:
		if(event is InputEventMouseButton and event.pressed and player.hand[card].has_point(get_global_mouse_position())):
			chosen_card = card
