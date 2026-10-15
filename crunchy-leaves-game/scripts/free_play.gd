extends Node2D

@onready var pause_menu_animations = $"Pause Menu Animations"

var leaf = preload("res://scenes/leaf.tscn")
#var object = preload("res://scenes/apple.tscn")

# pause menu
var pause_menu_open : bool = false
@onready var pause_menu = $"Pause Menu/PauseMenu"

# score 
@onready var timer_for_spawn = $"Timer for Spawn"
@onready var score_label = $"HUD/Score Panel/Score Label"
@onready var score: int = 0 # starting score

# music
@onready var music = $Music

# overlay 
@onready var transition = $Overlay/Transition
@onready var darkness = $Overlay/Darkness
@onready var whiteness = $Overlay/Whiteness

# backgrounds
@onready var happy = $HUD/Background/Happy


# Called when the node enters the scene tree for the first time.
func _ready():
	transition.fade_out_black()
	_setup_level()
	_start_spawn()
	
	
# -----------------
# STARTER FUNCTIONS
# -----------------

func _start_spawn() -> void:
	# begin to spawn in leaves
	timer_for_spawn.timeout.connect(spawn)
	timer_for_spawn.start()

func _setup_level() -> void:	
	# Connect apples
	var apples = $Apples
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(crunch_leaf)
	
	# Connect pause screen
	pause_menu.resume.connect(resume_game)
	pause_menu.quit.connect(quit_game)
	pause_menu.flip_card.connect(flip_card)
	pause_menu.flip_back.connect(flip_back)
	pause_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE # unclickable at first
	
# -----------------
# SPAWN OBJECTS
# -----------------

func spawn() -> void:
	var instance = leaf.instantiate()
	instance.collected.connect(crunch_leaf)
	
	# get a random x pos
	var x = randf_range(160, 1860)
	var y = randf_range(999-15, 999+15)
	instance.visible = false
	instance.position = Vector2(x, y)
	add_child(instance)
	instance.spawn()
	
# -----------------
# SCORE MANAGEMENT
# -----------------

func crunch_leaf() -> void:
	# one point for every leaf
	score += 1
	score_label.text = "Score: %s" % score

	
# --------------
# MANAGE MUSIC
# --------------

func _fade_music(duration: float):
	var tween = create_tween()
	# Interpolate volume_db from current volume down to -80 dB (silence)
	tween.tween_property(music, "volume_db", -80.0, duration)

# ------------------
# MANAGE PAUSE MENU
# ------------------

func _on_pause_menu_button_pressed():
	if pause_menu_open:
		resume_game()
	else:
		pause_game()

func resume_game():
	get_viewport().gui_release_focus()
	pause_menu_animations.play("close_pause_menu")
	pause_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pause_menu_open = false
	await pause_menu_animations.animation_finished
	
	# unpause game
	get_tree().paused = false 
	
func pause_game():
	# pause game
	get_tree().paused = true
	
	pause_menu_animations.play("open_pause_menu")
	await pause_menu_animations.animation_finished
	pause_menu.mouse_filter = Control.MOUSE_FILTER_STOP
	pause_menu_open = true
	
func quit_game():
	# exit to main menu
	get_viewport().gui_release_focus()
	_fade_music(0.5)
	await transition.fade_in_black()
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	
func flip_card():
	pause_menu_animations.play("flip_pause_button")
	
func flip_back():
	pause_menu_animations.play("flip_back_pause_button")
