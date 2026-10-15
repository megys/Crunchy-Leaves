extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var audio_stream_player = $AudioStreamPlayer
var walking : bool = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta):
	
	# Add animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"
		
	# manage walking sound
	if not is_on_floor() or velocity.x == 0:
		stop_walking_sound()
	else: 
		start_walking_sound()
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jumping"

	# Handle jump.
	if Input.is_action_just_pressed("jump_wasd") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left_wasd", "right_wasd")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
	if direction == 1.0: # turn right
		animated_sprite_2d.flip_h = false
	elif direction == -1.0: # turn left
		animated_sprite_2d.flip_h = true
		

func start_walking_sound():
	if not walking: # just started walking
		#audio_stream_player.play()
		audio_stream_player.volume_db = -10
		walking = true
	
func stop_walking_sound():
	if walking: # just stopped walking
		#audio_stream_player.stop()
		audio_stream_player.volume_db = -80
		walking = false
