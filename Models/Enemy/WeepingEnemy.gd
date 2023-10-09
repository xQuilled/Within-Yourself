extends KinematicBody

onready var anim = $AnimationPlayer
onready var anim2 = $Anims
onready var lookat = $LookAt
var found = false
var player
var target = null

export var speed = 1.5

var path = []
var cur_path_idx = 0
var velocity = Vector3.ZERO
var threshold = .1
var enabled = true

onready var nav = get_parent()

func _ready():
	yield(owner, "ready")
	target = owner.player
	anim.play("Covering")

func move_to_target():
	if global_transform.origin.distance_to(path[cur_path_idx]) < threshold:
		path.remove(0)
	else:
		var direction = path[cur_path_idx] - global_transform.origin
		velocity = direction.normalized() * speed
# warning-ignore:return_value_discarded
		move_and_slide(velocity, Vector3.UP)
		
func get_target_path(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)

func _physics_process(_delta):
	if found:
		global_transform.origin = lerp(global_transform.origin, player.jumpscare_location.global_transform.origin, 0.2)
	elif enabled:
		if path.size() > 0:
			move_to_target()

func _on_Detector_body_entered(body):
	if body.get_name() == "Player":
		if not body.jumpscared:
			player = body
			player.jumpscared = true
			player.jumpscare(lookat.global_transform.origin)
			anim2.play("switch")
			$CollisionShape.queue_free()
			found = true
			$Timer.stop()
			rotation_degrees.y = player.head.rotation_degrees.y


func _on_Timer_timeout():
	get_target_path(target.global_transform.origin)
	if enabled:
		look_at(target.global_transform.origin, Vector3.UP)
		rotation_degrees.x = 0
		rotation_degrees.y = clamp(rotation_degrees.y, -180, 180) - 180
		$AnimationTree.set("parameters/AnimType/blend_amount", ((randi() % 3) - 1))

func _on_VisibilityNotifier_camera_entered(_camera):
	enabled = false


func _on_VisibilityNotifier_camera_exited(_camera):
	enabled = true
