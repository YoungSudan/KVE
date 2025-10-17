extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(_delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED
	
	if velocity.length() > 0:
		if input_direction.x < 0:
			animated_sprite.play("Walk_Left")
		elif input_direction.x > 0:
			animated_sprite.play("Walk_Right")
		elif input_direction.y < 0:
			animated_sprite.play("Walk_Up")
		elif input_direction.y > 0:
			animated_sprite.play("Walk_Down")
	else:
		# Handle idle animations based on the last direction faced
		# You might store the last direction in a variable
		animated_sprite.play("Idle") # Or a more sophisticated idle based on last movement
	
	if Input.is_action_just_pressed("ui_accept"):
		animated_sprite.play("Fight_right")
	
	move_and_slide()


#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#print("Jumping")
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#var upDown := Input.get_axis("ui_down", "ui_up")
	## print("Left or Right")
	#
	#if direction:
		#
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	#
	#if upDown:
		#velocity.y = direction * SPEED
	#else: 
		#velocity.y = move_toward(velocity.x, 0, SPEED)
		#
	#move_and_slide()
