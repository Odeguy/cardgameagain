extends Node2D

var card_name: String
var effect: String
var front: bool = false
var _color: Color
var font_color: Color
var font: Variant
var font_size: int
var text_time: int = 1
var loaded: bool
var points: int

func _ready():
	loaded = false
	switch_side("front")
	load_text(true)

func switch_side(side: String):
	front = !front
	
func set_color(font_color_entered: Color):
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
	$PanelContainer/NameLabel.clear()
	if(font_color != null): $PanelContainer/NameLabel.push_color(font_color)
	if(font_size != null): $PanelContainer/NameLabel.push_font_size(font_size)
	if(font != null): $PanelContainer/NameLabel.push_font(font)
	
	$PanelContainer/EffectLabel.clear()
	if(font_color != null): $PanelContainer/EffectLabel.push_color(font_color)
	if(font_size != null): $PanelContainer/EffectLabel.push_font_size(font_size)
	if(font != null): $PanelContainer/EffectLabel.push_font(font)
	
	$PanelContainer/PointsLabel.clear()
	if(font_color != null): $PanelContainer/PointsLabel.push_color(font_color)
	if(font_size != null): $PanelContainer/PointsLabel.push_font_size(font_size * 3)
	if(font != null): $PanelContainer/PointsLabel.push_font(font)
	
func has_point(point: Vector2) -> bool:
	return $PanelContainer.panel.get_draw_rect().has_point(to_local(point))
	

func get_size() -> Vector2:
	return $PanelContainer.size * $PanelContainer.scale
	
func get_card_name() -> String:
	return card_name

func get_effect() -> String:
	return effect

func get_font_color() -> Color:
	return font_color
	
func get__color() -> Color:
	return _color
	
func get_font() -> String:
	return font
	
func get_font_size() -> int:
	return font_size
	
func get_points() -> int:
	return points

func load_text(gradually: bool):
	$PanelContainer/NameLabel.clear()
	$PanelContainer/EffectLabel.clear()
	$PanelContainer/PointsLabel.clear()
	re_push()
	var effect_with_int = effect #effect but [points value] is replaced with the actual number
	while effect_with_int.find("[points value]") != -1:
		effect_with_int = effect_with_int.substr(0, effect_with_int.find("[points value]")) + str(points) + effect_with_int.substr(effect_with_int.find("[points value]") + "[points value]".length())
	if gradually:
		loaded = false
		for char in card_name:
			$PanelContainer/NameLabel.append_text(char)
			await get_tree().create_timer(text_time / card_name.length()).timeout
		for char in effect_with_int:
			$PanelContainer/EffectLabel.append_text(char)
			await get_tree().create_timer(text_time / effect.length()).timeout
	else:
		$PanelContainer/NameLabel.append_text(card_name)
		$PanelContainer/EffectLabel.append_text(effect_with_int)
	$PanelContainer/PointsLabel.append_text(str(points))
	loaded = true

func extend_margin(length: int, duration: int) -> void:
	var tween = get_tree().create_tween()
	var stylebox := $PanelContainer.get_theme_stylebox("panel") as StyleBoxFlat
	if stylebox == null:
		push_error("No StyleBoxFlat found for 'panel'")
		return

	# Ensure you're not modifying a shared resource
	if not $PanelContainer.has_theme_stylebox_override("panel"):
		stylebox = stylebox.duplicate()
		$PanelContainer.add_theme_stylebox_override("panel", stylebox)

	# Tween the border width directly
	tween.tween_property(stylebox, "expand_margin_left", length, duration)

@onready var z_default: int = z_index
@onready var unextended_length: int = $PanelContainer.size.x
@onready var first_position: Vector2 = $PanelContainer.position	
func _on_panel_container_mouse_entered():
	z_index = 1000
	extend_margin(unextended_length, 1)
	#load_text(true)
	
func _on_panel_container_mouse_exited():
	await extend_margin(10, 1)
	z_index = z_default
