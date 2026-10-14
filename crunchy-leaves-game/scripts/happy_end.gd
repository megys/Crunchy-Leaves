extends Control
@onready var transition = $CanvasLayer/Transition

func _ready():
	transition.fade_out_white()
	await get_tree().create_timer(1.0).timeout
	_on_play_again_pressed()

func _on_play_again_pressed():
	await transition.fade_in_black()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
