extends Spatial

signal summon

func open():
	$AnimationPlayer.play("open")

func summon():
	emit_signal("summon")
