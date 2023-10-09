extends MeshInstance

var timer = Timer.new()
onready var light = get_child(0)
var enabled = true
export var multiplier : float = 1.0
export var max_light : float = 0.5

func _ready():
	add_child(timer)
	timer.wait_time = rand_range(0.1, 10)
	timer.emit_signal("timeout")
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", self, "_on_Timer_timeout")

func _process(delta):
	if light.light_energy < max_light and enabled:
		get_active_material(0).emission_energy += delta * 2
		light.light_energy += delta * multiplier

func _on_Timer_timeout():
	timer.wait_time = rand_range(0.1, 10)
	timer.start()
	light.light_energy = max_light/5
	get_active_material(0).emission_energy = 1

func kill():
	enabled = false
	timer.stop()
	light.light_energy = 0.3
