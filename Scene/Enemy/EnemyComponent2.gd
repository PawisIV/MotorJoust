extends Node2D

export var MaxHP = 20
export var acceleration = 200.0
export var max_speed = 400.0
export var friction = 0
var knockback_duration = 0.3
var knockback_timer = 0.0
var isknockback = false

# Variables for AI behavior
var circle_radius = 25  # Distance from the player to circle around
var rotation_speed = 1.0  # Speed of circling around the player

onready var player
onready var Text = get_node("PhysicComponent/RichTextLabel")
onready var spit = get_node("PhysicComponent/Sprite")
var direction_to_player = Vector2.ZERO
var input_vector = Vector2.ZERO
onready var p_node = get_node("PhysicComponent")
onready var h_node = get_node("HealthComponent")

func _ready():
	add_to_group("enemies")
	player = get_node("/root/MainScene/PlayerNode/PhysicComponent")
	p_node.on_set_variable(acceleration, max_speed, friction)
	h_node._setMaxHP(MaxHP)

func _physics_process(delta):
	Text.text = "\nHP :" + str(h_node._returnHealthPercen()*100) +"%"+ "\nInput Vector :" + str(input_vector)
	var direction_to_player = (player.global_position - p_node.global_position).normalized()
	var perpendicular = Vector2(-direction_to_player.y, direction_to_player.x)
	input_vector = direction_to_player + perpendicular * rotation_speed
	_send_movement_input(input_vector)
	_animUpdate(input_vector)

func _animUpdate(input_vector): #Debug Placeholder
	var angle_degrees = input_vector.angle() * 180 / PI  
	if angle_degrees < 0:
		angle_degrees += 360
	if angle_degrees >= 337.5 or angle_degrees < 22.5:
		spit.rotation_degrees = 0           # Right
	elif angle_degrees >= 22.5 and angle_degrees < 67.5:
		spit.rotation_degrees = -45         # Up-Right
	elif angle_degrees >= 67.5 and angle_degrees < 112.5:
		spit.rotation_degrees = -90         # Up
	elif angle_degrees >= 112.5 and angle_degrees < 157.5:
		spit.rotation_degrees = -135        # Up-Left
	elif angle_degrees >= 157.5 and angle_degrees < 202.5:
		spit.rotation_degrees = 180         # Left
	elif angle_degrees >= 202.5 and angle_degrees < 247.5:
		spit.rotation_degrees = 135         # Down-Left
	elif angle_degrees >= 247.5 and angle_degrees < 292.5:
		spit.rotation_degrees = 90          # Down
	elif angle_degrees >= 292.5 and angle_degrees < 337.5:
		spit.rotation_degrees = 45          # Down-Right

func _send_movement_input(input_vector):
	p_node._on_override_input(input_vector)
	if input_vector == Vector2.ZERO:
		p_node.emit_signal("no_input")

func _on_HealthComponent_died():
	queue_free()

func _health_update(type : String, amount):
	h_node.emit_signal("update_health", type, amount)
	if type == 'damage':
		isknockback = true
