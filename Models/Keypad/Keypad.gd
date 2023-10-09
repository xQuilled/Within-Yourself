extends Spatial

export var code = "1234"
var input = ""
var completed = false
var incorrect = false
onready var anims = $AnimationPlayer
onready var label = $Viewport/Label
onready var screen = $Screen

signal completed

func pressed(var num):
	if not completed:
		input += String(num)
		label.text = input
		if input.length() == code.length():
			if input == code:
				anims.play("correct")
			else:
				anims.play("incorrect")
			completed = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "correct":
		emit_signal("completed")
	if anim_name == "incorrect":
		completed = false
		input = ""
		label.text = ""
		screen.modulate = Color(1, 1, 1, 1)
