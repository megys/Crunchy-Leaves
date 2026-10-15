extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var animation_player = $AnimationPlayer


const SPEED = 300.0
const JUMP_VELOCITY = -800.0

func _ready():
	animation_player.play("hover")


func _physics_process(delta):
	
	# Add animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jumping"

	# Handle jump.
	if Input.is_action_just_pressed("jump_space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left_arrow", "right_arrow")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
	if direction == 1.0: # turn right
		animated_sprite_2d.flip_h = false
	elif direction == -1.0: # turn left
		animated_sprite_2d.flip_h = true
		
