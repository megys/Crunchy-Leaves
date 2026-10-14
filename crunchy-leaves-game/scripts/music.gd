extends Node2D

@onready var happy_song = $"Happy Song"
@onready var sad_song = $"Sad Song"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _play_happy() -> void:
	happy_song.play()

func _play_sad() -> void:
	sad_song.play()
