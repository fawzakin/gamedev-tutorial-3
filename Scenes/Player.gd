extends KinematicBody2D

export (int) var speed = 400
export (int) var jump = -600
export (int) var GRAVITY = 1200

const UP = Vector2(0,-1)
var velocity = Vector2()
var jump_count = 2

func do_move():
	velocity.x = 0
	if Input.is_action_pressed('move_right'):
		velocity.x += speed
	if Input.is_action_pressed('move_left'):
		velocity.x -= speed

func do_jump():
	if Input.is_action_pressed('move_jump') and jump_count > 0:
		velocity.y = jump
		jump_count -= 1

func _input(event):
	do_jump()
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	do_move()
	velocity = move_and_slide(velocity, UP)
	if is_on_floor():
		print("touch down!")
		reset_jump()
	else:
		print("not touch down!")
	
func reset_jump():
	jump_count = 2
