extends KinematicBody2D

signal laser_shoot
signal player_died
const SPEED := 600
const default_x_scale = 0.4
const immortal_x_scale = 2
var immortal := false

var player_explosion_scene = load("res://objects/ParticlesPlayerExplosion.tscn")

func _ready():
	print("Ship is ready")
	var camera = get_parent().get_node("MainCamera")
	self.connect("laser_shoot", camera, "_on_player_laser_shoot")
	var game = get_parent()
	self.connect("player_died", game, "player_is_ded")
	print(game)
	

func toggle_immortal():
	if (!immortal):
		scale.x = immortal_x_scale
		immortal = true
		play_immortal_song()
		
	else:
		scale.x = default_x_scale
		immortal = false
		stop_immortal_song()

func play_immortal_song():
	$ImmortalSong.play()

func stop_immortal_song():
	$ImmortalSong.stop()

func _physics_process(delta: float) -> void:
	var velocity := Vector2()
	
	if (Input.is_action_pressed("ui_left")):
		velocity.x = - SPEED
		
	if (Input.is_action_pressed("ui_right")):
		velocity.x = SPEED
		
	if (Input.is_action_pressed("ui_up")):
		velocity.y = - SPEED
		
	if (Input.is_action_pressed("ui_down")):
		velocity.y = SPEED
		
	move_and_collide(velocity * delta)
		

func _unhandled_key_input(event: InputEventKey) -> void:
	if (event.is_action_pressed("shoot")):
		$LaserWeapon.shoot()
		emit_signal("laser_shoot")


func explode():
	var player_explosion = player_explosion_scene.instance()
	player_explosion.position = self.position
	get_parent().add_child(player_explosion)
	player_explosion.emitting = true
	
	emit_signal("player_died")
	
	queue_free()

func _on_Hitbox_body_shape_entered(body_id, body, body_shape, area_shape):
	
	if (!body):
		return
	
	if (body.is_in_group("star")):
		body.call_deferred("explode")
		if(!immortal):
			$ImmortalTimer.start()
			toggle_immortal()
	
	if (!self.is_queued_for_deletion() and body.is_in_group("asteroids")):
		if (immortal):
			body.call_deferred("explode")
		else:
			explode()
		

func _on_ImmortalTimer_timeout():
	$ImmortalTimer.stop()
	toggle_immortal()
