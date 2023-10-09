extends KinematicBody

onready var head = $Head
onready var head_x = $Head/HeadXRotation
onready var flashlight = $Flashlight
onready var flashlight_light = $Flashlight/SpotLight
onready var flashlight_sound = $Flashlight/FlashlightSound
onready var flashlight_timer = $Flashlight/FlashlightTimer
onready var anim_tree = $Head/HeadXRotation/Camera/AnimationTree
onready var cast = $Head/HeadXRotation/Camera/Cast
onready var step_sound = $Step
onready var camera = $Head/HeadXRotation/Camera
onready var jumpscare_location = $Head/JumpscareLocation
onready var jumpscare_anim = $Jumpscare
onready var stages_anim = $Stages

var stage1_timer = Timer.new()

onready var sensitivity : float = -$"/root/Public".sensitivity
var anim_blend : float = 0
var can_move : bool = true
var can_look : bool = true
var equipped : bool = false
var door_cancelled : bool = false
var opening_door : bool = false
var jumpscared : bool = false

const SPEED : float = 2.5
const FLASHLIGHT_FOLLOW_SPEED : float = 15.0
const ANIM_SMOOTHING_SPEED : float = 8.0

func _ready():
	flashlight_light.visible = $"/root/Public".flashlight
	$CanvasLayer2/Anim.play("fade")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Head/HeadXRotation/Camera/motion_blur.visible = true
	$CanvasLayer2/Cover.set("shader_param/abberation_amount", 0.1)

func _input(event):
	if event is InputEventMouseMotion and can_look:
		head.rotation_degrees.y += sensitivity * event.relative.x
		head_x.rotation_degrees.x += sensitivity * event.relative.y
		head_x.rotation_degrees.x = clamp(head_x.rotation_degrees.x, -89, 89)
	
	if Input.is_action_just_pressed("flashlight"):
		if flashlight_timer.is_stopped():
			flashlight_light.visible = !flashlight_light.visible
			$"/root/Public".flashlight = flashlight_light.visible
			flashlight_sound.play()
			flashlight_timer.start()
	
	

func _process(delta):
	cast.cast_to.z = -(abs(head_x.rotation.x * 2) + 1)
	make_flashlight_follow(delta)
	
	var head_basis = head.get_global_transform().basis
	var direction = Vector3.ZERO
	
	if can_move:
		if Input.is_action_pressed("up"):
			direction -= head_basis.z
		elif Input.is_action_pressed("down"):
			direction += head_basis.z
		if Input.is_action_pressed("left"):
			direction -= head_basis.x
		elif Input.is_action_pressed("right"):
			direction += head_basis.x
		
	direction = direction.normalized()
# warning-ignore:return_value_discarded
	move_and_slide(direction * SPEED * anim_blend)
	
	anim_blend = lerp(anim_blend, direction.length(), delta * ANIM_SMOOTHING_SPEED)
	anim_tree.set("parameters/blend_position", anim_blend)
	if Input.is_action_just_pressed("interact"):
		if cast.is_colliding():
			if not opening_door:
				if cast.get_collider().get_name() == "Door":
					can_move = false
					opening_door = true
					$"/root/Public".play_door()
					$CanvasLayer2/Anim.play_backwards("fade")
					get_parent().door()
				if cast.get_collider().get_name() == "Door2":
					get_parent().door2()
				if cast.get_collider().get_name() == "Door3":
					can_move = false
					opening_door = true
					$"/root/Public".play_door()
					$CanvasLayer2/Anim.play_backwards("fade")
					get_parent().door3()
			if not equipped:
				if cast.get_collider().get_name() == "Paper":
					$Flashlight/Hand/Paper.visible = true
					get_parent().collect_paper()
					equipped = true
			else:
				if cast.get_collider().get_name() == "Chute":
					equipped = false
					if $Flashlight/Hand/Paper.visible == true:
						get_parent().throw()
					for i in $Flashlight/Hand.get_children():
						i.visible = false
			
			if cast.get_collider().get_name().substr(0, 3) == "Pad":
				cast.get_collider().get_parent().pressed(cast.get_collider().get_name().substr(3, 4))
	

func make_flashlight_follow(delta):
	flashlight.rotation.y = lerp(flashlight.rotation.y, head.rotation.y, delta * FLASHLIGHT_FOLLOW_SPEED)
	flashlight.rotation.x = lerp(flashlight.rotation.x, head_x.rotation.x, delta * FLASHLIGHT_FOLLOW_SPEED)


func step():
	step_sound.play()


func jumpscare(var location):
	get_parent().jumpscare()
	$Head/JumpscareLocation/JumpscareLight.light_energy = 4
	$Head/HeadXRotation/Camera/motion_blur.motion_blur = 6.0
	$Stages.stop()
	jumpscare_anim.get_animation("jumpscare").track_set_key_value(0, 0, camera.fov)
	jumpscare_anim.play("jumpscare")
	$JumpscareSound.play()
	can_move = false
	can_look = false
	head_x.rotation = Vector3.ZERO
	rotation_degrees.y = 0
	head.look_at(location, Vector3.UP)
	head_x.rotation.x = head.rotation.x
	head.rotation.x = 0
	camera.add_trauma(1)
	


func _on_Jumpscare_animation_finished(_anim_name):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/DeathScreen.tscn")


func stage1():
	stages_anim.play("stage1")
	$StageTimers/StageTimer.start()
	$StageTimers/StageTick.start()
	$CanvasLayer/LabelCover.visible = true

func _on_Stage1Timer_timeout():
	$StageTimers/StageTick.paused = true
	$StageTimers/StageTick.stop()
	$StageTimers/NoisePink.stop()
	$CanvasLayer/LabelCover.visible = false
	$StageTimers/VerifyStop.start()


func _on_Stage1Tick_timeout():
	$CanvasLayer/LabelCover.visible = !$CanvasLayer/LabelCover.visible
	$StageTimers/StageTick.wait_time = rand_range(0.01, 0.1)
	if $StageTimers/NoisePink.playing:
		$StageTimers/NoisePink.stop()
	else:
		$StageTimers/NoisePink.play()
	
	if $StageTimers/StageTimer.is_stopped():
		$StageTimers/NoisePink.stop()

func stage2():
	stages_anim.play("dontlookaway")
	$StageTimers/StageTimer.wait_time = 1.4
	$StageTimers/StageTimer.start()
	$StageTimers/StageTick.start()
	$CanvasLayer/LabelCover.visible = true

func stage3():
	stages_anim.play("stage3")
	$StageTimers/StageTimer.wait_time = 1.4
	$StageTimers/StageTimer.start()
	$StageTimers/StageTick.start()
	$CanvasLayer/LabelCover.visible = true

func _on_Stages_animation_finished(anim_name):
	if anim_name == "stage1":
		get_parent().out_of_time()






func _on_VerifyStop_timeout():
	$StageTimers/NoisePink.stop()
