extends Node

var stage = 1
var ao = true
var volume = 100
var fullscreen = false
var flashlight = true
var sensitivity = 0.1

func _ready():
	OS.window_fullscreen = fullscreen

func _input(_event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		fullscreen = OS.window_fullscreen

func play_door():
	$Door.play()
