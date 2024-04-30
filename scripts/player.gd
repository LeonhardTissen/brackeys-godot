extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -215.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var checkpoint = Vector2(0, 0)

var is_dead = false

func _ready():
	# Set the checkpoint to the initial position.
	checkpoint = position

func _go_to_checkpoint():
	# Teleport the player to the checkpoint.
	position = checkpoint

func kill():
	print("Player died!")

	is_dead = true
	animated_sprite.play('death')
	Engine.time_scale = 0.3

	await get_tree().create_timer(0.4).timeout

	# Reset the player.
	is_dead = false
	Engine.time_scale = 1.0
	_go_to_checkpoint()

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound

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
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction != 0:
		animated_sprite.flip_h = direction < 0
		
	# Play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play('idle')
		else:
			animated_sprite.play('run')
	else:
		animated_sprite.play('jumping')
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
