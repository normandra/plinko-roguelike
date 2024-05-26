@tool
extends Node2D

@export var ball : PackedScene
@export var pong : PackedScene
@export var score_pad : PackedScene

var mid_point = Vector2(576,200)
var pad_start = Vector2(350,550)
var pad_counts = 14

var global_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	create_pyramid()
	create_score_pads()
	
func create_score_pads():
	var colorGrad = Gradient.new()
	colorGrad.interpolation_mode = 2
	colorGrad.interpolation_color_space = 2
	colorGrad.add_point(1, Color.AQUAMARINE)
	colorGrad.add_point(7, Color.INDIAN_RED)
	colorGrad.add_point(8, Color.INDIAN_RED)
	colorGrad.add_point(14, Color.AQUAMARINE)
	
	for i in range(pad_counts):
		var pad = score_pad.instantiate()
		var pad_size = pad.get_node("./CollisionShape2D").shape.size
		pad.color = colorGrad.sample(i + 1)
		pad.position = pad_start
		pad.position.x += i * pad_size.x
		
		var textLabel = pad.get_node("./ScoreText")
		var score = 0
		if i < pad_counts / 2:
			score = 7 - i
		else:
			score = 1 + (i - 7)
		textLabel.text = str(score)	
		pad.score = score
		pad.scored.connect(_on_scored)
		add_child(pad)

	
func create_pyramid():
	# Create a pyramid of pong sticks
	var level = 1
	var distance = 55
	for i in range(10):
		var last_position = mid_point
		last_position.x -= (level - 1) * distance / 2
		for j in range(level):
			var pong_scene = pong.instantiate()
			pong_scene.position = last_position
			pong_scene.position.y += level * 30
			pong_scene.play_sound.connect(_on_ball_colide)
			add_child(pong_scene)
			
			last_position = pong_scene.position
			last_position.x += distance
			last_position.y = mid_point.y
		level += 1
	
func _unhandled_input(event):
	if event.is_action_pressed("add_ball"):
		var b_item = ball.instantiate()
		b_item.position = event.position
		add_child(b_item)
		
func _on_timer_timeout():
	var b_item = ball.instantiate()
	b_item.position = mid_point
	b_item.position.y -= 50
	b_item.position.x += randi_range(-5,5)
	add_child(b_item)
	
func _on_scored(score):
	global_score += 1
	$Control/RichTextLabel.text = "Score: %s" % global_score
	$MoneySound.play()
	
func _on_ball_colide():
	$StickSound.play()
