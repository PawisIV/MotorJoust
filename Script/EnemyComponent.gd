extends Node2D

export var MaxHP = 200
export var acceleration = 200.0
export var max_speed = 400.0
export var friction = 0
# Variables for AI behavior
var charge_speed = 400  
var zigzag_pattern = false
var charging = false
var random_charge_threshold = 0.01  


# Player reference and AI state
onready var player
var direction_to_player = Vector2.ZERO
var input_vector = Vector2.ZERO
onready var p_node = get_node("PhysicComponent")
onready var h_node = get_node("HealthComponent")

func _ready():
	add_to_group("enemies")
	player = get_node("/root/MainScene/PlayerNode/PhysicComponent")
	p_node.on_set_variable(acceleration,max_speed,friction)
	h_node._setMaxHP(MaxHP)

func _physics_process(delta):
	input_vector = (player.global_position - p_node.global_position).normalized()
	_send_movement_input(input_vector)





func _send_movement_input(input_vector):
	p_node._on_override_input(input_vector)
	if input_vector == Vector2.ZERO:
		p_node.emit_signal("no_input")


func _on_HealthComponent_died():
	print("die")
	pass # Replace with function body.
