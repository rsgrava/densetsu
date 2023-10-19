extends CharacterBody2D

const MAX_SPEED = 120.0
const cardinals = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

@onready var animation = $AnimatedSprite2D

var state = States.IDLE_MOVING
var old_direction = Vector2.DOWN
var old_dinput = Vector2(0, 0)

enum States {
	IDLE_MOVING
}

func _physics_process(delta):
	match state:
		States.IDLE_MOVING:
			update_idle_moving(delta)
	move_and_slide()

func update_idle_moving(delta):
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

	var direction
	if dinput == Vector2(0, 0):
		direction = old_direction
	else:
		var distances = []
		for cardinal in cardinals:
			distances.append(dinput.distance_to(cardinal))
		direction = cardinals[distances.find(distances.min())]
	
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
