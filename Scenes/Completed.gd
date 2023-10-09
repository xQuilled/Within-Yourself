extends Control

onready var anim = $AnimationPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	anim.play("fade_in")
	$Theme.volume_db = -5


func _on_Menu_pressed():
	anim.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Menu.tscn")


