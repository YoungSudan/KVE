# player.gd
# Works in Godot 4.x
# Node structure:
# CharacterBody2D
# └── AnimatedSprite2D

extends CharacterBody2D

# -------------------------------
# 🧩 CONFIGURATION
# -------------------------------
const SPEED: float = 300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Whether the player is currently performing an attack animation
var is_attacking: bool = false

# Track the last movement direction (used for idle + attack)
# We'll store it as a string ("left", "right", "up", "down")
var last_direction: String = "Down"


# -------------------------------
# 🚀 READY
# -------------------------------
func _ready() -> void:
	# Connect the animation_finished signal (no arguments in Godot 4)
	animated_sprite.connect("animation_finished", Callable(self, "_on_animated_sprite_animation_finished"))


# -------------------------------
# 🕹️ INPUT HANDLING
# -------------------------------
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not is_attacking:
		_start_attack()


# -------------------------------
# ⚙️ PHYSICS PROCESS
# -------------------------------
func _physics_process(delta: float) -> void:
	# Prevent movement while attacking
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Read directional input
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * SPEED
	move_and_slide()
	
	# Handle walking animations
	if input_dir.length() > 0:
		# Determine dominant direction (horizontal vs vertical)
		if abs(input_dir.x) > abs(input_dir.y):
			if input_dir.x > 0:
				last_direction = "Right"
				animated_sprite.play("Walk_Right")
			else:
				last_direction = "Left"
				animated_sprite.play("Walk_Left")
		else:
			if input_dir.y > 0:
				last_direction = "Down"
				animated_sprite.play("Walk_Down")
			else:
				last_direction = "Up"
				animated_sprite.play("Walk_Up")
	else:
		# Idle animation based on last facing direction
		animated_sprite.play("Idle_" + last_direction)


# -------------------------------
# 💥 ATTACK LOGIC
# -------------------------------
func _start_attack() -> void:
	is_attacking = true
	velocity = Vector2.ZERO
	move_and_slide()
	
	# Play the appropriate fight animation based on last facing direction
	match last_direction:
		"Up":
			animated_sprite.play("Fight_Up")
		"Down":
			animated_sprite.play("Fight_Down")
		"Left":
			animated_sprite.play("Fight_Left")
		"Right":
			animated_sprite.play("Fight_Right")


# -------------------------------
# 🎬 SIGNAL HANDLER
# -------------------------------
func _on_animated_sprite_animation_finished() -> void:
	# When the fight animation ends, return to the idle animation of the same direction
	if animated_sprite.animation.begins_with("Fight_"):
		is_attacking = false
		animated_sprite.play("Idle_" + last_direction)
		animated_sprite.frame = 0
		
	if animated_sprite.animation.begins_with("Idle_"):
		is_attacking = false
		animated_sprite.play("Idle_" + last_direction)
		animated_sprite.frame = 0
