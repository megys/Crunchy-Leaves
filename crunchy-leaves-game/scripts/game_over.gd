extends Control

@onready var transition = $CanvasLayer/Transition
@onready var music = $Music

func _ready():
	transition.fade_out_black()
	

func _on_play_again_pressed():
	_fade_music(0.5)
	await transition.fade_in_black()
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")

func _fade_music(duration: float):
	var tween = create_tween()
	# Interpolate volume_db from current volume down to -80 dB (silence)
	tween.tween_property(music, "volume_db", -80.0, duration)
