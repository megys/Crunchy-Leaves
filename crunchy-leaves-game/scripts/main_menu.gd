extends Control

@export var unlock : bool 

# Called when the node enters the scene tree for the first time.
func _ready():
	unlock = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")


func _on_settings_pressed():
	pass # Replace with function body.


func _on_controls_pressed():
	pass # Replace with function body.

func _on_credits_pressed():
	pass # Replace with function body.


func _on_free_play_pressed():
	pass # Replace with function body.
