extends Node2D


# Reference to the physics component
onready var physics_component = $PhysicComponent
onready var p_node = get_node("PhysicComponent")
func _ready():
	if physics_component == null:
		print("PhysicsComponent is null, check the node path!")
	else:
		print("PhysicsComponent loaded successfully: ", physics_component)
func _process(_delta):
		#Handle InputData#
	if Input.is_action_pressed("ui_up"):
		p_node.emit_signal("go_up")
	elif Input.is_action_pressed("ui_down"):
		p_node.emit_signal("go_down")
	if Input.is_action_pressed("ui_left"):
		p_node.emit_signal("go_left")
	elif Input.is_action_pressed("ui_right"):
		p_node.emit_signal("go_right")
	else:
		p_node.emit_signal("no_input")




