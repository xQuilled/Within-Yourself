extends Camera

export (OpenSimplexNoise) var noise
export(float, 0, 1) var trauma = 0.0

export var max_x = 0.10
export var max_y = 0.10
export var max_r = 30
export var multiplier_r = 3

export var time_scale = 600

export(float, 0, 1) var decay = 0.0

var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()

func add_trauma(trauma_in):
	trauma = clamp(trauma + trauma_in, 0, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	var shake = pow(trauma, 2)
	translation.x = noise.get_noise_3d(time * time_scale * multiplier_r, 0, 0) * max_x * shake
	translation.y = noise.get_noise_3d(0, time * time_scale, 0) * max_y * shake
	rotation_degrees.z = noise.get_noise_3d(0, 0, time * time_scale) * max_r * shake
	
	if trauma > 0: trauma = clamp(trauma - (delta * decay), 0, 1)
