extends Area2D
@onready var collected_sound = $CollectedSound
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer

@onready var little_crunch_sound = $"Little Crunch Sound"
@onready var big_crunch_sound = $"Big Crunch Sound"


# leaf sprites
@onready var leaf_0 = $Leaves/Leaf0
@onready var leaf_1 = $Leaves/Leaf1
@onready var leaf_2 = $Leaves/Leaf2
@onready var leaf_3 = $Leaves/Leaf3
@onready var leaf_4 = $Leaves/Leaf4
@onready var leaf_5 = $Leaves/Leaf5

signal collected

func _ready():
	# all leaves are initially hidden
	leaf_0.visible = false
	leaf_1.visible = false
	leaf_2.visible = false
	leaf_3.visible = false
	leaf_4.visible = false
	leaf_5.visible = false
	
	_choose_leaf()

func spawn():
	_disable_collision()
	animation_player.play("spawn")
	await animation_player.animation_finished
	_enable_collision()

func _on_body_entered(body):
	if body is CharacterBody2D && body.velocity == Vector2.ZERO:
		# character is not moving
		pass
	elif body.velocity.y != 0: # BIG CRUNCH / jumping crunch
		crunch(0)
	else: # Little Crunch /walking crunch
		crunch(1)

		
func crunch(type: int):
	match type:
		0: # Big Crunch
			big_crunch_sound.play()
		1: # Little Crunch
			little_crunch_sound.play()
		
	# animation_player.play("crunch")
	self.visible = false
		
	collected.emit()
	call_deferred("_disable_collision")
	#await animation_player.animation_finished
	await collected_sound.finished
	queue_free()

func _disable_collision():
	collision_shape_2d.disabled = true

func _enable_collision():
	collision_shape_2d.disabled = false

	
func _choose_leaf():
	# choose which leaf to generate
	var leaf = randi_range(0,5)
	match leaf:
		0:
			leaf_0.visible = true
		1:
			leaf_1.visible = true
		2: 
			leaf_2.visible = true
		3:
			leaf_3.visible = true
		4:
			leaf_4.visible = true
		5: 
			leaf_5.visible = true
