@tool
extends Area2D

@export var color : Color
var default_font : Font = ThemeDB.fallback_font;
var score = 1

signal scored(score)

func _draw():
	var rect_size = $"./CollisionShape2D".shape.size
	var rect_position = Vector2(-rect_size.x / 2,  -rect_size.y / 2)
	var rectangle = Rect2(rect_position, $"./CollisionShape2D".shape.size)
	draw_rect(rectangle, color)
	

func _on_body_entered(body):
	body.queue_free()
	scored.emit(score)
