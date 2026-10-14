extends Control

@onready var animation_player = $AnimationPlayer

func fade_in_black() -> void: # 0.5s
	animation_player.play("fade_in_black")
	await animation_player.animation_finished

func fade_out_black() -> void: # 0.5s
	animation_player.play("fade_out_black")
	await animation_player.animation_finished
 
func fade_in_white() -> void: # 0.5s
	animation_player.play("fade_in_white")
	await animation_player.animation_finished
	
func fade_in_white_4s() -> void: # 4s
	animation_player.play("fade_in_white_4s")
	await animation_player.animation_finished

func fade_out_white() -> void: # 0.5s
	animation_player.play("fade_out_white")
