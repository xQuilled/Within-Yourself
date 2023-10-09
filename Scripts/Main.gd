extends Spatial

func _ready():
	$WorldEnvironment.environment.ambient_light_color = Color(0, 0, 0)
	$WorldEnvironment.environment.glow_enabled = true
	$WorldEnvironment.environment.ssao_enabled = $"/root/Public".ao
	if $"/root/Public".stage == 2:
		$Breathing.play()
func door():
	$DoorTimer.start()


func _on_DoorTimer_timeout():
	if $"/root/Public".stage == 1:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Stage1.tscn")
	elif$"/root/Public".stage == 2:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Stage2.tscn")
	elif$"/root/Public".stage == 3:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Stage3.tscn")


