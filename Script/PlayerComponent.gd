extends Node2D
export var acceleration = 200.0
export var max_speed = 800.0
export var friction = 0
# Reference to the physics component
onready var physics_component = $PhysicComponent
onready var p_node = get_node("PhysicComponent")

func _ready():
	if physics_component == null:
		print("PhysicsComponent is null, check the node path!")
	else:
		print("PhysicsComponent loaded successfully: ", physics_component)
	p_node.emit_signal("set_var",acceleration,max_speed,friction)

func _process(_delta):
	if Input.is_action_pressed("ui_up"):
		p_node.emit_signal("force_up", 1)
	elif Input.is_action_pressed("ui_down"):
		p_node.emit_signal("force_down", 1)
	else:
	# If neither up nor down is pressed, we send 0
		p_node.emit_signal("force_up", 0)  # Neutral value for vertical movement
		p_node.emit_signal("force_down", 0)  # Neutral value for vertical movement

	if Input.is_action_pressed("ui_left"):
		p_node.emit_signal("force_left", 1)
	elif Input.is_action_pressed("ui_right"):
		p_node.emit_signal("force_right", 1)
	else:
	# If neither left nor right is pressed, we send 0
		p_node.emit_signal("force_left", 0)  # Neutral value for horizontal movement
		p_node.emit_signal("force_right", 0)  # Neutral value for horizontal movement

# Emit no input signal only when no direction is pressed
	if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		p_node.emit_signal("no_input")
