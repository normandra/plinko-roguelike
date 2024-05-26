extends Node2D

@export var color : Color

func _draw():
	draw_circle(position, $"../CollisionShape2D".shape.radius, color)
