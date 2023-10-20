extends CharacterBody2D

const MAX_SPEED = 120.0
const JUMP_DELAY = 0.20
const JUMP_DISTANCE = 100.0
const JUMP_POWER = -100.0
const GRAVITY = 300.0
const cardinals = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

@onready var animation = $AnimatedSprite2D

var state = States.IDLE_MOVING
var old_direction = Vector2.DOWN
var direction = Vector2.DOWN
var old_dinput = Vector2(0, 0)
var jump_timer = 0.0
var animation_velocity_y = 0.0

enum States {
	IDLE_MOVING,
	JUMPING_START,
	JUMPING_END,
	JUMPING,
}

func _physics_process(delta):
	match state:
		States.IDLE_MOVING:
			update_idle_moving()
		States.JUMPING_START:
			update_jumping_start(delta)
		States.JUMPING_END:
			update_jumping_end(delta)
		States.JUMPING:
			update_jumping(delta)
	move_and_slide()

func update_idle_moving():
	var dinput = Vector2(
		Input.get_axis("player_left", "player_right"),
		Input.get_axis("player_up", "player_down")
	).limit_length()

	if dinput.length() >= 0.75:
		dinput = dinput.normalized()

	if dinput.x:
		velocity.x = dinput.x * MAX_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, MAX_SPEED)	
	if dinput.y:
		velocity.y = dinput.y * MAX_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, MAX_SPEED)

	if dinput == Vector2(0, 0):
		direction = old_direction
	else:
		var distances = []
		for cardinal in cardinals:
			distances.append(dinput.distance_to(cardinal))
		direction = cardinals[distances.find(distances.min())]

	if Input.is_action_just_pressed("jump"):
		velocity = Vector2(0, 0)
		old_dinput = Vector2(0, 0)
		state = States.JUMPING_START
		match direction:
			Vector2.UP:
				animation.play("jumping_start_end_up")
			Vector2.DOWN:
				animation.play("jumping_start_end_down")
			Vector2.LEFT:
				animation.play("jumping_start_end_left")
			Vector2.RIGHT:
				animation.play("jumping_start_end_right")
		return

	if direction != old_direction or \
		(old_dinput.length() == 0 and dinput.length() != 0) or \
		(
			(old_dinput.length() < 0.5 and old_dinput.length() > 0) and \
			(dinput.length() >= 0.5 or dinput.length() == 0)
		) or \
		(old_dinput.length() >= 0.5 and dinput.length() < 0.5):
		if dinput.length() == 0:
			match direction:
				Vector2.UP:
					animation.play("idle_up")
				Vector2.DOWN:
					animation.play("idle_down")
				Vector2.LEFT:
					animation.play("idle_left")
				Vector2.RIGHT:
					animation.play("idle_right")
		elif dinput.length() < 0.5:
			match direction:
				Vector2.UP:
					animation.play("walking_up")
				Vector2.DOWN:
					animation.play("walking_down")
				Vector2.LEFT:
					animation.play("walking_left")
				Vector2.RIGHT:
					animation.play("walking_right")
		else:
			match direction:
				Vector2.UP:
					animation.play("running_up")
				Vector2.DOWN:
					animation.play("running_down")
				Vector2.LEFT:
					animation.play("running_left")
				Vector2.RIGHT:
					animation.play("running_right")

	old_direction = direction
	old_dinput = dinput

func update_jumping_start(delta):
	jump_timer += delta
	if jump_timer > JUMP_DELAY:
		jump_timer = 0.0
		animation_velocity_y = JUMP_POWER
		state = States.JUMPING
		match direction:
			Vector2.UP:
				velocity.y = -JUMP_DISTANCE
				animation.play("jumping_up")
			Vector2.DOWN:
				velocity.y = JUMP_DISTANCE
				animation.play("jumping_down")
			Vector2.LEFT:
				velocity.x = -JUMP_DISTANCE
				animation.play("jumping_left")
			Vector2.RIGHT:
				velocity.x = JUMP_DISTANCE
				animation.play("jumping_right")
	
func update_jumping_end(delta):
	jump_timer += delta
	if jump_timer > JUMP_DELAY:
		jump_timer = 0.0
		state = States.IDLE_MOVING
		match direction:
			Vector2.UP:
				animation.play("idle_up")
			Vector2.DOWN:
				animation.play("idle_down")
			Vector2.LEFT:
				animation.play("idle_left")
			Vector2.RIGHT:
				animation.play("idle_right")

func update_jumping(delta):
	animation.position.y += animation_velocity_y * delta
	animation_velocity_y += GRAVITY * delta
		
	if animation.position.y >= 0.0:
		animation.position.y = 0.0
		velocity = Vector2(0, 0)
		state = States.JUMPING_END
		match direction:
			Vector2.UP:
				animation.play("jumping_start_end_up")
			Vector2.DOWN:
				animation.play("jumping_start_end_down")
			Vector2.LEFT:
				animation.play("jumping_start_end_left")
			Vector2.RIGHT:
				animation.play("jumping_start_end_right")
		return

	if animation_velocity_y > 0.0:
		match direction:
			Vector2.UP:
				animation.play("falling_up")
			Vector2.DOWN:
				animation.play("falling_down")
			Vector2.LEFT:
				animation.play("falling_left")
			Vector2.RIGHT:
				animation.play("falling_right")
