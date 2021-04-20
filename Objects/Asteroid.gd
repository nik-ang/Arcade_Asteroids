extends RigidBody2D

signal explode
signal score_changed
var is_exploded := false
var asteroid_small_scene := load("res://objects/AsteroidSmall.tscn")
var explosion_particles_scene := load("res://objects/ParticlesAsteroidExplosion.tscn")
var points_scored_scene := load("res://UI/PointsScored.tscn")
var score_value = 100

var rng = RandomNumberGenerator.new()

func _ready():
	var main_camera = get_node("/root/Game/MainCamera")
	self.connect("explode", main_camera, "asteroid_exploded")
	
	var label = get_tree().get_root().get_node("Game/GUI/MarginContainer/HBoxContainer/VBoxContainer/Score")
	self.connect("score_changed", label, "update_score")
	
	

func explosion_particles():
	var explosion_particles = explosion_particles_scene.instance()
	explosion_particles.position = self.position
	get_parent().add_child(explosion_particles)
	explosion_particles.emitting = true
	
func spawn_score():
	var points_scored = points_scored_scene.instance()
	points_scored.get_node("Label").text = str(score_value)
	points_scored.position = self.position
	
	get_parent().add_child(points_scored)

func randomize_trajectory(asteroid):
	
	asteroid.angular_velocity = rand_range(-4, 4)
	asteroid.angular_damp = 0
	
	rng.randomize()
	var lv_x = rng.randi_range(-1, 1)
	var lv_y = rng.randi_range(-1 ,1)
	
	asteroid.linear_velocity = Vector2(lv_x * 400, lv_y * 400)

func spawn_asteroid_small():
	var asteroid_small = asteroid_small_scene.instance()
	asteroid_small.position = self.position
	get_parent().add_child(asteroid_small)
	randomize_trajectory(asteroid_small)
	
func spawn_asteroids_small(quantity: int):
	for i in range(quantity):
		spawn_asteroid_small()
		
		
func play_explosion_sound(pitch_scale: float):
	var explosion_sound = AudioStreamPlayer2D.new()
	explosion_sound.stream = load("res://Assets/assets/audio/sfx/AsteroidExplosion.wav")
	explosion_sound.pitch_scale = pitch_scale
	explosion_sound.position = self.position
	get_parent().add_child(explosion_sound)
	explosion_sound.play(0)

func explode():
	if is_exploded:
		return
		
	is_exploded = true
	
	explosion_particles()
	play_explosion_sound(1)
	
	emit_signal("explode")
	emit_signal("score_changed", score_value)
	spawn_score()
	
	spawn_asteroids_small(4)
	
	get_parent().remove_child(self)
	queue_free()

func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport):
	queue_free()
