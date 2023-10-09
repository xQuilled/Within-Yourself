extends Spatial

var collected = false
var thrown = false
onready var text = $Assets/TV/Viewport/Text
onready var audio_click = $Assets/TV/Click
var door_cancelled = false
var dialogue_pos = 0

var dialogue = [
"A NOTE OF MEMORY\nLOST DEEP BELOW",
"SEND IT BACK\nAND HE'LL AWAKE",
"OR LAST HERE\n FOR YOUR ETERNITIY"
]

func _ready():
	$WorldEnvironment.environment.ambient_light_color = Color(0, 0, 0)
	$WorldEnvironment.environment.glow_enabled = true
	$Assets/TV/Viewport/PhraseTick.start()
	$WorldEnvironment.environment.ssao_enabled = $"/root/Public".ao
	
func jumpscare():
	$Assets/Lamps/Lamp1.kill()
	$Assets/Lamps/Lamp2.kill()
	$Assets/Lamps/Lamp3.kill()
	$Assets/Lamps/Lamp4.kill()


func _on_Detector_body_entered(body):
	if body.get_name() == "Player":
		body.stage1()
		$Detector.queue_free()

func collect_paper():
	$Assets/Paper.queue_free()
	collected = true

func throw():
	thrown = true
	$Enemy.translation.y = 0
	$Detector.translation.y = 0
	$Enemy.visible = true
	$Laugh.play()

func out_of_time():
	$Player.translation = Vector3(1.68, 1.2, 1)
	$Player.door_cancelled = true
	door_cancelled = true

func _on_LetterTick_timeout():
	if text.visible_characters < dialogue[dialogue_pos - 1].length():
		text.visible_characters += 1
		audio_click.pitch_scale = rand_range(0.8, 1.2)
		$Assets/TV/Viewport/LetterTick.wait_time = rand_range(0.02,0.15)
		audio_click.play()
	elif $Assets/TV/Viewport/PhraseTick.is_stopped():
		$Assets/TV/Viewport/PhraseTick.start()


func _on_PhraseTick_timeout():
	if $Assets/TV/Viewport/LetterTick.is_stopped():
		$Assets/TV/Viewport/LetterTick.start()
	text.visible_characters = 0
	if dialogue_pos == dialogue.size():
		$Assets/TV/Viewport/Eyes.visible = true
		text.text = ""
		$Assets/TV/Viewport/LetterTick.stop()
		$Assets/TV/Roar.play()
	else:
		text.text = dialogue[dialogue_pos]
		dialogue_pos += 1
		

func door():
	$DoorTimer.start()

func _on_DoorTimer_timeout():
	if not door_cancelled:
		if thrown == true:
			$"/root/Public".stage = 2
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Main.tscn")
	else:
		door_cancelled = false
