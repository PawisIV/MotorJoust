extends Node2D

export var MaxHP = 200
export var acceleration = 200.0
export var max_speed = 400.0
export var friction = 0
var knockback_duration = 0.3
var knockback_timer = 0.0
var isknockback = false
# Variables for AI behavior
var charge_speed = 400  
var zigzag_pattern = false
var charging = false
var random_charge_threshold = 0.01  


onready var HealthComponent = get_node("HealthComponent")
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
	##########


func _physics_process(delta):
	input_vector = (player.global_position - p_node.global_position).normalized()
	_send_movement_input(input_vector)


func _send_movement_input(input_vector):
	p_node._on_override_input(input_vector)
	if input_vector == Vector2.ZERO:
		p_node.emit_signal("no_input")


func _on_HealthComponent_died():
	queue_free()
	pass # Replace with function body.

func _health_update(type : String,amount ) :
	h_node.emit_signal("update_health",type,amount)
	if type == 'damage' : #Knockback
		isknockback = true
	
