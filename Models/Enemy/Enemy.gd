extends Spatial

onready var anim = $AnimationPlayer
onready var anim2 = $Anims
onready var lookat = $LookAt
var found = false
var player

func _ready():
	anim.play("ReachingOut")

func _physics_process(_delta):
	if found:
		global_transform.origin = lerp(global_transform.origin, player.jumpscare_location.global_transform.origin, 0.2)

func _on_Detector_body_entered(body):
	if body.get_name() == "Player":
		if not body.jumpscared:
			player = body
			player.jumpscared = true
			player.jumpscare(lookat.global_transform.origin)
			anim2.play("switch")
			$Enemy.queue_free()
			found = true
		rotation_degrees.y = player.head.rotation_degrees.y
