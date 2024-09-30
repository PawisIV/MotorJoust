extends KinematicBody2D

var speed = 200
var velocity = Vector2()

func _ready():
	pass
func _physics_process(delta):
	_handled_input()
func _handled_input():
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	velocity.normalized()
	move_and_slide(velocity*speed)
