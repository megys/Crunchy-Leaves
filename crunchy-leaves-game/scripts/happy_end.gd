extends Control
@onready var transition = $CanvasLayer/Transition
@onready var animation_player = $CanvasLayer/AnimationPlayer
@onready var music = $CanvasLayer/Music

func _ready():
	animation_player.play("roll_credits")
	await animation_player.animation_finished
	return_to_main()
	
func return_to_main():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
