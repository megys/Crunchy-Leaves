extends Control

@onready var free_play = $"File/Card/Title Card/VBoxContainer/Free Play"
@onready var transition = $Transition
@onready var animation_player = $AnimationPlayer

# audio
var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("SFX")
@onready var music = $Music

# Called when the node enters the scene tree for the first time.
func _ready():
	transition.fade_out_black()
	if Global.UnlockFreePlay:
		free_play.disabled = false
	else:
		free_play.disabled = true
		

func _on_play_pressed():
	fade_music(0.5)
	await transition.fade_in_black()
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")


func _on_settings_pressed():
	animation_player.play("flip_to_settings")


func _on_controls_pressed():
	animation_player.play("flip_to_controls")

func _on_credits_pressed():
	animation_player.play("flip_to_credits")


func _on_free_play_pressed():
	fade_music(0.5)
	pass # Replace with function body.


func _on_back_pressed():
	animation_player.play("flip_back")

# -------------
# MANAGE AUDIO
# -------------

func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))

func fade_music(duration: float):
	var tween = create_tween()
	# Interpolate volume_db from current volume down to -80 dB (silence)
	tween.tween_property(music, "volume_db", -80.0, duration)
