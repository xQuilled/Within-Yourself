extends Spatial

onready var transtion_anim = $CanvasLayer/AnimationPlayer
onready var switch_anim = $CanvasLayer/Anims
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	transtion_anim.play("fade_in")
	$"/root/Public".stage = 1
	$WorldEnvironment.environment.ambient_light_color = Color(0, 0, 0)
	$WorldEnvironment.environment.glow_enabled = true
	
	
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db($"/root/Public".volume/100.0))
	$CanvasLayer/Menu/Panel2/Settings/Right/Volume.value = $"/root/Public".volume
	$CanvasLayer/Menu/Panel2/Settings/Right/Sensitivity.value = $"/root/Public".sensitivity
	if $CanvasLayer/Menu/Panel2/Settings/Right/AO.selected == 0:
		$"/root/Public".ao = true
	else:
		$"/root/Public".ao = false
	$WorldEnvironment.environment.ssao_enabled = $"/root/Public".ao
	
	if OS.window_fullscreen:
		$CanvasLayer/Menu/Panel2/Settings/Right/Fullscreen.selected = 0
	else:
		$CanvasLayer/Menu/Panel2/Settings/Right/Fullscreen.selected = 1


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Main.tscn")

func _on_Play_pressed():
	transtion_anim.play("fade_out")


func _on_Settings_pressed():
	switch_anim.play_backwards("switch")
	$CanvasLayer/Menu/Panel2/Settings.visible = true
	$CanvasLayer/Menu/Panel2/Credits.visible = false


func _on_Credits_pressed():
	switch_anim.play_backwards("switch")
	$CanvasLayer/Menu/Panel2/Settings.visible = false
	$CanvasLayer/Menu/Panel2/Credits.visible = true


func _on_Close_pressed():
	switch_anim.play("switch")


func _on_Exit_pressed():
	get_tree().quit()


func _on_RichTextLabel_meta_clicked(meta):
# warning-ignore:return_value_discarded
	OS.shell_open(meta)



func _input(_event):
	if Input.is_action_just_pressed("fullscreen"):
		if !OS.window_fullscreen:
			$CanvasLayer/Menu/Panel2/Settings/Right/Fullscreen.selected = 0
		else:
			$CanvasLayer/Menu/Panel2/Settings/Right/Fullscreen.selected = 1


func _on_AO_item_selected(index):
	if index == 0:
		$"/root/Public".ao = true
	else:
		$"/root/Public".ao = false
	$WorldEnvironment.environment.ssao_enabled = $"/root/Public".ao

func _on_Fullscreen_item_selected(index):
	if index == 0:
		OS.window_fullscreen = true
		$"/root/Public".fullscreen = true
	else:
		OS.window_fullscreen = false
		$"/root/Public".fullscreen = false

func _on_SpinBox_value_changed(value):
	$"/root/Public".volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db($"/root/Public".volume/100.0))
	





func _on_Sensitivity_value_changed(value):
	$"/root/Public".sensitivity = value
