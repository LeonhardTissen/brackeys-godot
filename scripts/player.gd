extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var hurt_sound = $HurtSound

const SPEED = 100.0
const JUMP_VELOCITY = -125.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var checkpoint = Vector2(0, 0)

# The total amount of jump frames in which the player can hold down the jump button and go higher (variable jump height).
const total_jump_frames = 16
var current_jump_frame = 0

# Total coyote time frames
const total_coyote_frames = 12
var current_coyote_frame = 0

var is_dead = false

func _ready():
	# Set the checkpoint to the initial position.
	checkpoint = position

func _go_to_checkpoint():
	# Teleport the player to the checkpoint.
	position = checkpoint

func kill():
	if is_dead:
		return
		
	print("Player died!")

	is_dead = true
	animated_sprite.play('death')
	Engine.time_scale = 0.3
	hurt_sound.play()

	await get_tree().create_timer(0.4).timeout

	# Reset the player.
	is_dead = false
	Engine.time_scale = 1.0
	_go_to_checkpoint()

func set_new_checkpoint():
	checkpoint = position

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle death.
	if is_dead:
		velocity.x = 0
		move_and_slide()
		return

	# Handle jump.
	if Input.is_action_pressed("jump"):
		if is_on_floor() or current_coyote_frame > 0:
			# Player just jumped.
			velocity.y = JUMP_VELOCITY
			jump_sound.play()
			current_jump_frame = total_jump_frames
			current_coyote_frame = 0
		elif current_jump_frame > 0:
			# Player can still gain height by holding the jump button.
			velocity.y = JUMP_VELOCITY
			current_jump_frame -= 1
	else:
		# Reset variable jump height.
		current_jump_frame = 0

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction != 0:
		animated_sprite.flip_h = direction < 0
		
	if is_on_floor():
		# Reset the coyote time frame.
		current_coyote_frame = total_coyote_frames

		# Play the idle or run animation.
		if direction == 0:
			animated_sprite.play('idle')
		else:
			animated_sprite.play('run')
	else:
		# Play the jump animation.
		animated_sprite.play('jumping')
		current_coyote_frame -= 1
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
