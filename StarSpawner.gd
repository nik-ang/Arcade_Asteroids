extends Node

var star_scene := load("res://objects/Star.tscn")

func spawn_star():
	
	var star = star_scene.instance()
	add_child(star)
	
	set_star_trajectory(star)
	set_star_position(star)
	
func set_star_position(star):
		var rect = get_viewport().size
		star.position = Vector2(rand_range(0, rect.x), -100)
		
func set_star_trajectory(star):
	star.angular_velocity = rand_range(-4, 4)
	star.angular_damp = 0
	star.linear_velocity = Vector2(rand_range(-300, 300), 300)
	star.linear_damp = 0



func _on_StarTimer_timeout():
	spawn_star()
