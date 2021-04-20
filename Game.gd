extends Node2D

var player_scene = load("res://characters/Player.tscn")
var is_game_over := false


func player_is_ded():
	
	$AsteroidSpawner/SpawnTimer.stop()
	$StarSpawner/StarTimer.stop()
	
	for asteroid in get_tree().get_nodes_in_group("asteroids"):
		if(!asteroid.is_queued_for_deletion() and asteroid.has_node("AudioStreamPlayer2D")):
			asteroid.get_node("AudioStreamPlayer2D").stop()
	
	$GameOverTimer.start()
	print("Game Over")
	

func _unhandled_input(event: InputEvent):
	if(is_game_over and event.is_action_released("restart_game")):
		restart_game()
		
		
func respawn_player():
	var player = player_scene.instance()
	player.position = Vector2(626, 680)
	add_child(player)

func undo_game_over():
	$GameOverLabel.visible = false

func restart_game():
	respawn_player()
	undo_game_over()
	is_game_over = false
	$AsteroidSpawner/SpawnTimer.start()
	$StarSpawner/StarTimer.start()


func _on_GameOverTimer_timeout():
	$GameOverLabel.visible = true
	is_game_over = true
