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

onready var HealthComponent = get_node("HealthComponent")
onready var player
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
	# Calculate the direction to the player
	var direction_to_player = (player.global_position - p_node.global_position).normalized()
	
	# Create a perpendicular vector to make the enemy circle around the player
	var perpendicular = Vector2(-direction_to_player.y, direction_to_player.x)
	
	# Combine both the direction to the player and the perpendicular to make a circular movement
	input_vector = direction_to_player + perpendicular * rotation_speed
	
	_send_movement_input(input_vector)

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
