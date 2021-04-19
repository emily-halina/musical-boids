extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(0, 0)
var max_x = 5
var max_y = 5
var rng = RandomNumberGenerator.new()
onready var sfx = get_node("sfx")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	get_node("Timer").wait_time = rng.randf_range(0.5, 3.0)

func _on_Timer_timeout():
	# scale the pitch according to boid position, add constant to avoid too high
	sfx.pitch_scale = sqrt(pow(position.x, 2) + pow(position.y, 2))*0.01 + -3
	print(sfx.pitch_scale)
	sfx.play()
	
