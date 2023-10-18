extends CharacterBody2D

const SPEED = 120.0

func _physics_process(delta):
	var x_axis = Input.get_axis("player_left", "player_right")
	if x_axis:
		velocity.x = x_axis * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var y_axis = Input.get_axis("player_up", "player_down")
	if y_axis:
		velocity.y = y_axis * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
