extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var boid_scene = load("res://boid.tscn")
onready var boids = [boid_scene.instance(),boid_scene.instance(),boid_scene.instance(),boid_scene.instance(),boid_scene.instance(),boid_scene.instance(), boid_scene.instance(),boid_scene.instance(),boid_scene.instance(),boid_scene.instance(),boid_scene.instance(),boid_scene.instance()]
#onready var boids = [boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance(), boid_scene.instance()]
var rng = RandomNumberGenerator.new()

var max_x = 3
var max_y = 3

const screen_x = 1024
const screen_y = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	# init the boids and randomize their positions
	rng.randomize()
	for boid in boids:
		get_node(".").add_child(boid)
		boid.position = Vector2(rng.randf_range(0, 1024), rng.randf_range(0, 600))

func boid_movement(boids):
	# move the boids according to 3 rules:
	# 1. go towards the centre of mass
	# 2. if you're too close to other boids, don't collide
	# 3. try to match the velocity of other boids
	var v1 = Vector2(0, 0)
	var v2 = Vector2(0, 0)
	var v3 = Vector2(0, 0)
	for boid in boids:
		v1 = rule1(boid, boids)
		v2 = rule2(boid, boids)
		v3 = rule3(boid, boids)
		boid.velocity += (v1 + v2 + v3)
		boid.position += boid.velocity
		
func rule1(boid, boids):
	# boids move towards centre of mass of the flocks
	var centre = Vector2(0,0)
	for other_boid in boids:
		if other_boid != boid:
			centre += other_boid.position
	centre = centre / (len(boids) - 1)
	return (centre - boid.position) / 800

func rule2(boid, boids):
	# don't collide with other boids if you get too close
	var anti_collide = Vector2(0, 0)
	var distance = 25
	for other_boid in boids:
		if other_boid != boid:
			if abs((other_boid.position.x - boid.position.x) + (other_boid.position.y - boid.position.y)) < distance:
				anti_collide -= (other_boid.position - boid.position)
	return anti_collide / 500

func rule3(boid, boids):
	# try to match velocity of other boids
	var velo_match = Vector2(0,0)
	for other_boid in boids:
		if other_boid != boid:
			velo_match += other_boid.velocity
	velo_match /= (len(boids) - 1)
	return (velo_match - boid.velocity) / 2
	
func velo_cap(boids):
	# velocity cap for boids
	for boid in boids:
		if boid.velocity.x > max_x:
			boid.velocity.x = max_x
		elif boid.velocity.x < -max_x:
			boid.velocity.x = -max_x
		if boid.velocity.y > max_y:
			boid.velocity.y = max_y
		elif boid.velocity.y < -max_y:
			boid.velocity.y = -max_y

func reset_pos(boids):
	# screenwrap
	for boid in boids:
		if boid.position.x < 0:
			boid.position.x = screen_x
		elif boid.position.x > screen_x:
			boid.position.x = 0
		if boid.position.y < 0:
			boid.position.y = screen_y
		elif boid.position.y > screen_y:
			boid.position.y = 0

# called every frame (delta is amount of time since last frame)
func _process(delta):
	# move the boids, handling screenwrap and capping their velocity
	boid_movement(boids)
	reset_pos(boids)
	velo_cap(boids)


func _on_Timer_timeout():
	pass # Replace with function body.
