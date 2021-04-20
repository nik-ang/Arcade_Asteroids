extends "res://objects/Asteroid.gd"

func _ready():
	self.score_value = 250

func explode():
	if is_exploded:
		return
		
	is_exploded = true
	
	play_explosion_sound(2)
	emit_signal("score_changed", self.score_value)
	self.spawn_score()
	
	get_parent().remove_child(self)
	queue_free()

