extends Spatial

onready var exposure_timer = $ExposureTimer
onready var player = $Player
onready var player_camera = $Player/Head/HeadXRotation/Camera
var exposure_to : float = 1.0


func _ready():
	$WorldEnvironment.environment.ambient_light_color = Color(0, 0, 0)
	$WorldEnvironment.environment.glow_enabled = true
	$WorldEnvironment.environment.ssao_enabled = $"/root/Public".ao
	player_camera.max_x = 0.05
	player_camera.max_y = 0.05
	player_camera.max_r = 10
	player_camera.time_scale = 60

func door2():
	$LockedDoor.play()

func door3():
	$DoorTimer.start()

func switch():
	player_camera.trauma = 1.0
	$Lamps/Lamp1/OmniLight.light_color = Color(0.8, 0.5, 0.5)
	$Lamps/Lamp2/OmniLight.light_color = Color(0.8, 0.5, 0.5)
	$Lamps/Lamp3/OmniLight.light_color = Color(0.8, 0.5, 0.5)
	$Lamps/Lamp4/OmniLight.light_color = Color(0.8, 0.5, 0.5)
	$Lamps/Lamp5/OmniLight.light_color = Color(0.8, 0.5, 0.5)
	$ExposureTimer.start()
	
func jumpscare():
	player_camera.time_scale = 600
	player_camera.max_x = 0.1
	player_camera.max_y = 0.1
	player_camera.max_r = 30

func _physics_process(_delta):
	$WorldEnvironment.environment.tonemap_exposure = lerp($WorldEnvironment.environment.tonemap_exposure, exposure_to, 0.2)
	
func _on_ExposureTimer_timeout():
	exposure_to = rand_range(1, 20)
	exposure_timer.wait_time = rand_range(0.01, 0.1)


func _on_Timer_timeout():
	player.stage3()
	switch()


func _on_DoorTimer_timeout():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Completed.tscn")

