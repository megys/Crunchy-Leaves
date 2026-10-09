extends Node2D

@export var spawn_timer : Timer
@export var score_timer : Timer
var object = preload("res://scenes/apple.tscn")

@onready var score_label = $"HUD/Score Panel/Score Label"
@onready var progress_bar = $HUD/ProgressBar
@onready var score: int = 10 # start at 0

# overlay 
@onready var darkness = $Overlay/Darkness

# backgrounds
@onready var happy = $HUD/Background/Happy


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_score()
	_setup_level()
	_start_score_degen()
	_start_spawn()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if score <= -10: # Game Over countdown ends
		get_tree().change_scene_to_file("res://scenes/Game Over.tscn")
	elif score >= 100:
		score_timer.stop() # score won't go down anymore
		await get_tree().create_timer(4.0).timeout # wait two seconds
		get_tree().change_scene_to_file("res://scenes/Happy End.tscn")
	
# -----------------
# STARTER FUNCTIONS
# -----------------
	
func _set_score() -> void:
	# instantiate progress bar/score
	progress_bar.value = score
	
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
			apple.collected.connect(increase_score)
	
# -----------------
# SPAWN OBJECTS
# -----------------

func spawn() -> void:
	var instance = object.instantiate()
	instance.collected.connect(increase_score)
	
	# get a random x pos
	var x = randf_range(30, 1890)
	instance.position = Vector2(x, 969)
	add_child(instance)
	
# -----------------
# SCORE MANAGEMENT
# -----------------

func increase_score() -> void:
	if score < 0: # Game Over countdown resets 
		score = 0
		clear_darkness() 
	score += 5
	score_label.text = "Score: %s" % score
	progress_bar.value += 5
	change_bg(progress_bar.value)

func update_score() -> void:
	# You lose 1 point for every Score Timer Wait Time
	score -= 1
	score_label.text = "Score: %s" % score
	if score >= 0:
		progress_bar.value -= 1
	else:
		darken(score*-1) # screen starts to darken
	change_bg(progress_bar.value)
	

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
