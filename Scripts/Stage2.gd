extends Spatial

var collected = false
var thrown = false
onready var player = $Player
onready var enemy = $Navigation/WeepingEnemy
onready var text = $Assets/TV/Viewport/Text
onready var audio_click = $Assets/TV/Click
onready var music = $Music
var door_cancelled = false
var dialogue_pos = 0

var dialogue = [
"A ROOM OF COLOURS\nAND GATES",
"BLOCKS YOU FROM\nCHANGING YOUR FATE",
"DON'T TURN YOUR BACK\nOR GO INSANE",
"FOR HE WILL STRIKE\nWHEN YOU LOOK AWAY"
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
	music.stop()

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
			$"/root/Public".stage = 3
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Main.tscn")
	else:
		door_cancelled = false





func _on_Keypad1_completed():
	$Assets/Gate1.open()


func _on_Gate_summon():
	player.stage2()
	enemy.translation = Vector3(-1.4, 0.06, -1.7)


func _on_Keypad2_completed():
	$Assets/Gate2.open()

func door2():
	if $"/root/Public".stage == 3:
		$LockedDoor.play()
	else:
		enemy.queue_free()
		$Laugh.play()
		$Music.stop()
		$LockedDoor.play()
		$"/root/Public".stage = 3
	
