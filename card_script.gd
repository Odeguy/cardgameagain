extends Node2D

var card_name
var effect
var front = false
var color
var font
var font_size

func _ready():
	$Body/Button.size = $Body/Shape.shape.size
	$Body/Button.visible = false
	toggle_side()

func toggle_side():
	if(front):
		$Body/Back.show()
		$Body/Front.hide()
	else:
		$Body/Back.hide()
		$Body/Front.show()
	front = !front
	
func set_color(color_entered: Color):
	color = color_entered
	re_push()

func set_font_size(size_entered: int):
	font_size = size_entered
	re_push()
	
func set_font(font_entered: String):
	font = font_entered
	re_push()
	
func set_card_name(name_entered: String):
	card_name = name_entered
	re_push()
	
func set_effect(effect_entered: String):
	effect = effect_entered
	re_push()

func re_push():
	$Body/Front/NameLabel.clear()
	if(color != null): $Body/Front/NameLabel.push_color(color)
	if(font_size != null): $Body/Front/NameLabel.push_font_size(font_size)
	if(font != null): $Body/Front/NameLabel.push_font(font)
	if(card_name != null): $Body/Front/NameLabel.append_text(card_name)
	
	$Body/Front/EffectLabel.clear()
	if(color != null): $Body/Front/EffectLabel.push_color(color)
	if(font_size != null): $Body/Front/EffectLabel.push_font_size(font_size)
	if(font != null): $Body/Front/EffectLabel.push_font(font)
	if(effect != null): $Body/Front/EffectLabel.append_text(effect)
	
func get_size() -> Vector2:
	return $Body/Shape.get_shape().size
	
func get_card_name() -> String:
	return card_name

func get_effect() -> String:
	return effect

func get_color() -> Color:
	return color
	
func get_font() -> String:
	return font
	
func get_font_size() -> int:
	return font_size

func has_point(point: Vector2) -> bool:
	return $Body/Shape.shape.get_rect().has_point(to_local(point))
