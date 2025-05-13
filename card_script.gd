extends Node2D

var card_name
var effect
var front = false
var back_color
var font_color
var font
var font_size
var text_time = 1
var loaded
var points

func _ready():
	loaded = false
	switch_side("front")
	load_text(true)

func switch_side(side: String):
	pass
	
func set_font_color(font_color_entered: Color):
	font_color = font_color_entered
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
	$Body/BackNameLabel.clear()
	if(font_color != null): $Body/BackNameLabel.push_font_color(font_color)
	if(font_size != null): $Body/BackNameLabel.push_font_size(font_size)
	if(font != null): $Body/BackNameLabel.push_font(font)
	
	$Body/BackEffectLabel.clear()
	if(font_color != null): $Body/BackEffectLabel.push_font_color(font_color)
	if(font_size != null): $Body/BackEffectLabel.push_font_size(font_size)
	if(font != null): $Body/BackEffectLabel.push_font(font)
	
	$Body/BackPointsLabel.clear()
	if(font_color != null): $Body/BackPointsLabel.push_font_color(font_color)
	if(font_size != null): $Body/BackPointsLabel.push_font_size(font_size * 3)
	if(font != null): $Body/BackPointsLabel.push_font(font)
	
func get_size() -> Vector2:
	return $Body/Shape.get_shape().size
	
func get_card_name() -> String:
	return card_name

func get_effect() -> String:
	return effect

func get_font_color() -> Color:
	return font_color
	
func get_back_color() -> Color:
	return back_color
	
func get_font() -> String:
	return font
	
func get_font_size() -> int:
	return font_size
	
func get_points() -> int:
	return points

func load_text(gradually):
	$Body/BackNameLabel.clear()
	$Body/BackEffectLabel.clear()
	$Body/BackPointsLabel.clear()
	re_push()
	var effect_with_int = effect #effect but [points value] is replaced with the actual number
	while effect_with_int.find("[points value]") != -1:
		effect_with_int = effect_with_int.substr(0, effect_with_int.find("[points value]")) + str(points) + effect_with_int.substr(effect_with_int.find("[points value]") + "[points value]".length())
	if gradually:
		loaded = false
		for char in card_name:
			$Body/BackNameLabel.append_text(char)
			await get_tree().create_timer(text_time / card_name.length()).timeout
		for char in effect_with_int:
			$Body/BackEffectLabel.append_text(char)
			await get_tree().create_timer(text_time / effect.length()).timeout
	else:
		$Body/BackNameLabel.append_text(card_name)
		$Body/BackEffectLabel.append_text(effect_with_int)
	$Body/BackPointsLabel.append_text(str(points))
	loaded = true
	
