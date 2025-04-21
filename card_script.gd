extends Node2D

var card_name
var effect
var front = false
var color
var font
var font_size
var text_time = 1
var loaded
var points

func _ready():
	loaded = false
	$Body/Button.size = $Body/Shape.shape.size
	$Body/Button.visible = false
	toggle_side()
	load_text(true)

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
	
func set_points(points_entered: int):
	points = points_entered
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
	
	$Body/Front/EffectLabel.clear()
	if(color != null): $Body/Front/EffectLabel.push_color(color)
	if(font_size != null): $Body/Front/EffectLabel.push_font_size(font_size)
	if(font != null): $Body/Front/EffectLabel.push_font(font)
	
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
	
func get_points() -> int:
	return points

func has_point(point: Vector2) -> bool:
	return $Body/Shape.shape.get_rect().has_point(to_local(point))
	
func load_text(gradually):
	$Body/Front/NameLabel.clear()
	$Body/Front/EffectLabel.clear()
	re_push()
	if gradually:
		loaded = false
		for char in card_name:
			$Body/Front/NameLabel.append_text(char)
			await get_tree().create_timer(text_time / card_name.length()).timeout
		for char in effect:
			$Body/Front/EffectLabel.append_text(char)
			await get_tree().create_timer(text_time / effect.length()).timeout
	else:
		$Body/Front/NameLabel.append_text(card_name)	
		$Body/Front/EffectLabel.append_text(effect)
	loaded = true
