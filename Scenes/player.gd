extends CharacterBody2D

@onready var anim_player = $AnimationPlayer;

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 0.0;

enum Action { Idle, Sprint }
var current_action = Action.Idle;

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()
	if direction != 0: # If moving, set sprite direction so it remembers which direction you were facing.
		$SpriteSheet.scale.x = direction;

func _process(_delta):
	update_animation();

func update_animation():
	if is_on_floor():
		if direction == 0:
			anim_player.play("Idle");
		else:
			anim_player.play("Sprint");
	else:
		if velocity.y < 0:
			anim_player.play("Jump");
		elif velocity.y > 0:
			anim_player.play("Fall");
