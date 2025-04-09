extends Node2D

var card_name
var effect
var front = false

func _ready():
	toggle_side()

func toggle_side():
	if(front):
		$Body/Back.show()
		$Body/Front.hide()
	else:
		$Body/Back.hide()
		$Body/Front.show()
	front = !front
