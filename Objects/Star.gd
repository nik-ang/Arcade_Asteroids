extends RigidBody2D

var exploded := false

func explode():
	if (exploded):
		return
		
	exploded = true
	
	if(!self.is_queued_for_deletion()):
		get_parent().remove_child(self)
		queue_free()
	

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if(!self.is_queued_for_deletion()):
		queue_free()
