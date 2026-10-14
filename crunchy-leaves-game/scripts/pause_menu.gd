extends Control

@onready var transition = $Transition
@onready var animation_player = $AnimationPlayer

# audio
var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("SFX")

signal resume
signal quit
signal flip_card
signal flip_back

func _on_resume_pressed():
	resume.emit()

func _on_settings_pressed():
	animation_player.play("flip_to_settings")
	flip_card.emit()


func _on_controls_pressed():
	animation_player.play("flip_to_controls")
	flip_card.emit()

func _on_credits_pressed():
	animation_player.play("flip_to_credits")
	flip_card.emit()


func _on_quit_pressed():
	quit.emit()

func _on_back_pressed():
	animation_player.play("flip_back")
	flip_back.emit()

# -------------
# MANAGE AUDIO
# -------------

func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))
