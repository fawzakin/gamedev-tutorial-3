extends KinematicBody2D

export (int) var speed = 400
export (int) var jump_first = 600
export (int) var jump_second = 600
export (float) var jump_delay = 0.166667 # Add 1/6 of a second of delay before a second jump can be performed.
export (int) var GRAVITY = 1200

const UP = Vector2(0,-1)
var velocity = Vector2()
var last_direction = 1
var can_jump = true # Can the player jump even in midair?
var current_jump_delay = 0

func _ready():
	$AnimatedSprite.play("idle")
	
func do_move():
	velocity.x = 0
	if Input.is_action_pressed('move_right'):
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
		last_direction = 1
		velocity.x += speed
	if Input.is_action_pressed('move_left'):
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true
		last_direction = -1
		velocity.x -= speed
	if velocity.x == 0:
		if last_direction == 1:
			$AnimatedSprite.play("idle")
			$AnimatedSprite.flip_h = false
		elif last_direction == -1:
			$AnimatedSprite.play("idle")
			$AnimatedSprite.flip_h = true

func do_jump():
	if Input.is_action_pressed('move_jump') and can_jump:
		if is_on_floor():
			velocity.y -= jump_first
			current_jump_delay = jump_delay
			$JumpAudio.play()
		elif not is_on_floor() and current_jump_delay <= 0: # Condition to do second jump
			velocity.y = 0
			velocity.y -= jump_second
			can_jump = false
			$JumpAudio.play()

func reset_jump():
	can_jump = true
	current_jump_delay = 0

func _input(event):
	do_jump()
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	print(current_jump_delay)
	do_move()
	velocity = move_and_slide(velocity, UP)
	if is_on_floor():
		reset_jump()
	elif not is_on_floor() and current_jump_delay > 0:
		current_jump_delay -= (delta + 0.000001)
	

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		global_position = Vector2(90,340)
