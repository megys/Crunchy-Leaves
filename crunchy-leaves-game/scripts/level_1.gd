extends Node2D

@onready var speech_bubble_animations = $"Speech Bubble Animations"
@onready var pause_menu_animations = $"Pause Menu Animations"

@onready var player = $Player
var leaf = preload("res://scenes/leaf.tscn")
#var object = preload("res://scenes/apple.tscn")

# pause menu
var pause_menu_open : bool = false
@onready var pause_menu_control = $"Pause Menu"
@onready var pause_menu = $"Pause Menu/PauseMenu"

# speech
@onready var speech_bubble = $"HUD/Speech Bubble"
@onready var eulogy = $"HUD/Speech Bubble/Eulogy"
var speaking : bool = false

# score 
@export var spawn_timer : Timer
@export var score_timer : Timer
var won : bool = false
var failed : bool = false
@onready var score_label = $"HUD/Score Panel/Score Label"
@onready var happy_bar = $"Happy Bar/Bar"
@onready var score: float = 10.0 # starting score

# music
@onready var happy_song = $"Happy Song"
@onready var sad_song = $"Sad Song"
var happy_switch : bool = false

# overlay 
@onready var transition = $Overlay/Transition
@onready var darkness = $Overlay/Darkness
@onready var whiteness = $Overlay/Whiteness

# backgrounds
@onready var happy = $HUD/Background/Happy


# Called when the node enters the scene tree for the first time.
func _ready():
	transition.fade_out_black()
	_set_score()
	_setup_level()
	_start_score_degen()
	_start_spawn()
	_start_speaking()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if score <= -10: # Game Over countdown ends
		sad_fail() # fail from being too sad 
	elif score >= 100 && failed == false:
		win()
		
	# music changes
	if score >= 50 && happy_switch == false:
		happy_switch = true
		_fade_in_music(happy_song, 2)
		_fade_out_music(sad_song, 2)
	elif score <50 && happy_switch == true:
		happy_switch = false
		_fade_in_music(sad_song, 2)
		_fade_out_music(happy_song, 2)
	
# -----------------
# STARTER FUNCTIONS
# -----------------
	
func _set_score() -> void:
	# instantiate progress bar/score
	happy_bar.value = score
	
func _start_score_degen() -> void:
	# score degenerates gradually
	score_timer.timeout.connect(update_score)
	score_timer.start()

func _start_spawn() -> void:
	# begin to spawn in leaves
	spawn_timer.timeout.connect(spawn)
	spawn_timer.start()

func _setup_level() -> void:	
	# set backgrounds
	happy.modulate.a = 0 # sad bg in full force
	darkness.modulate.a = 0 # not full darkness
	
	# Connect apples
	var apples = $Apples
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(crunch_leaf)
	
	# Connect eulogy
	eulogy.speaking_stopped.connect(_stop_speaking)
	
	# Connect pause screen
	pause_menu.resume.connect(resume_game)
	pause_menu.quit.connect(quit_game)
	pause_menu.flip_card.connect(flip_card)
	pause_menu.flip_back.connect(flip_back)
	pause_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE # unclickable at first
	
	_initialize_music()
	
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
	# don't invoke if already won
	if won == true || failed == true:
		pass
	
	# cannot crunch if no one is speaking
	if speaking == false:
		if won == false: # if you haven't already won
			fail()
		
	if score < 0: # Game Over countdown resets 
		score = 0
		clear_darkness() 
	
	if player.velocity.y != 0: # BIG CRUNCH / jumping crunch
		increase_score(5)
	elif player.velocity.x != 0: # Little Crunch /walking crunch
		increase_score(1)

	
func increase_score(value):
	score += value
	score_label.text = "Score: %s" % score
	happy_bar.value += value
	change_bg(happy_bar.value)

func update_score() -> void:
	# don't invoke if already won
	if won == true || failed == true:
		pass
		
	# You lose X point for every Score Timer Wait Time
	var point = 0.1
	score -= point
	score_label.text = "Score: %s" % score
	if score >= 0:
		happy_bar.value -= point
	else:
		darken(score*-1) # screen starts to darken
	change_bg(happy_bar.value)
	

func change_bg(value) -> void:
	var percent = value / 100.0
	# the happier you are, the brighter
	happy.modulate.a = percent

func darken(value) -> void:
	var percent = value / 10.0
	darkness.visible = true
	darkness.modulate.a = percent
	
func clear_darkness() -> void:
	darkness.visible = false
	darkness.modulate.a = 0

# -----------------
# MANAGE WIN/FAIL
# -----------------
func win() -> void:
	if won == false: # if you haven't already won
		won = true
		Global.UnlockFreePlay = true
		score_timer.stop() # score won't go down anymore
		_fade_all_music(4) # fade out over 4 s
		await transition.fade_in_white_4s()
		get_tree().change_scene_to_file("res://scenes/Happy End.tscn")
		
func fail() -> void:
	if failed == false: # if you haven't already failed
		failed = true
		_fade_all_music(0.5) # fade out over 0.5 s
		await transition.fade_in_black()
		get_tree().change_scene_to_file("res://scenes/Game Over.tscn")

func sad_fail() -> void:
	if failed == false: # if you haven't already failed
		failed = true
		_fade_all_music(0.5) # fade out over 0.5 s
		await transition.fade_in_black()
		get_tree().change_scene_to_file("res://scenes/Game Over Sad End.tscn")


# -----------------
# MANAGE SPEECH
# -----------------

func _start_speaking():	
	speech_bubble_animations.play("speech_bubble_open")
	# Wait until it finishes
	await speech_bubble_animations.animation_finished
	speaking = true # now you can crunch
	
func _stop_speaking():
	speech_bubble_animations.play("speech_bubble_close")
	# Wait until it finishes
	await speech_bubble_animations.animation_finished
	speaking = false # now you CANNOT crunch
	
	# wait 2-8 seconds for the moment of silence to pass
	var time = randf_range(2, 8)
	await get_tree().create_timer(time).timeout # wait four seconds
	_start_speaking()
	
# --------------
# MANAGE MUSIC
# --------------

func _initialize_music():
	# happy song starts as silent
	happy_song.volume_db = -80.0
	sad_song.volume_db = -15

func _music_get_happy():
	_fade_in_music(happy_song, 1)
	_fade_out_music(sad_song, 1)

func _music_get_sad():
	_fade_in_music(sad_song, 1)
	_fade_out_music(happy_song, 1)

func _fade_out_music(song, duration: float):
	var tween = create_tween()
	# Interpolate volume_db from current volume down to -80 dB (silence)
	tween.tween_property(song, "volume_db", -80.0, duration)
	
func _fade_in_music(song, duration: float):
	var tween = create_tween()
	# Interpolate volume_db from current volume up to 0 dB (normal)
	tween.tween_property(song, "volume_db", -15.0, duration)
	
func _fade_all_music(duration: float):
	_fade_out_music(happy_song, duration)
	_fade_out_music(sad_song, duration)

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
	_fade_all_music(0.5)
	await transition.fade_in_black()
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	
func flip_card():
	pause_menu_animations.play("flip_pause_button")
	
func flip_back():
	pause_menu_animations.play("flip_back_pause_button")
