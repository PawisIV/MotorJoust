extends Node2D
export var acceleration = 200.0
export var max_speed = 800.0
export var friction = 0
# Reference to the physics component
onready var physics_component = $PhysicComponent
onready var p_node = get_node("PhysicComponent")
var isAttacking
#onready var a_node = get_node("PhysicComponent/AnimationPlayer")
signal play_animation(anim_name,flip)
signal play_attack_anim(anim_name)
func _ready():
	if physics_component == null:
		print("PhysicsComponent is null, check the node path!")
	else:
		print("PhysicsComponent loaded successfully: ", physics_component)
	p_node.emit_signal("set_var",acceleration,max_speed,friction)


func _process(_delta):
	
	##################Handle Input###################
	if Input.is_action_pressed("ui_up"):
		p_node.emit_signal("force_up", 1)
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left") :
			emit_signal("play_animation","PlayerUpRight",true) 
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right") :
			emit_signal("play_animation","PlayerUpRight",false) 
		else :
			emit_signal("play_animation","PlayerUp",false) 
	elif Input.is_action_pressed("ui_down"):
		p_node.emit_signal("force_down", 1)
		if Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left") :
			emit_signal("play_animation","PlayerDownRight",true) 
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right") :
			emit_signal("play_animation","PlayerDownRight",false) 
		else :
			emit_signal("play_animation","PlayerDown",false) 
	else:
		p_node.emit_signal("force_up", 0)  # Neutral value for vertical movement
		p_node.emit_signal("force_down", 0)  # Neutral value for vertical movement
	if Input.is_action_pressed("ui_left"):
		p_node.emit_signal("force_left", 1)
		if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up") :
			emit_signal("play_animation","PlayerUpRight",true) 
		elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down") :
			emit_signal("play_animation","PlayerDownRight",true) 
		else :
			emit_signal("play_animation","PlayerRight",true) 
	elif Input.is_action_pressed("ui_right"):
		p_node.emit_signal("force_right", 1)
		if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up") :
			emit_signal("play_animation","PlayerUpRight",false) 
		elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down") :
			emit_signal("play_animation","PlayerDownRight",false) 
		else :
			emit_signal("play_animation","PlayerRight",false) 
	else:
		p_node.emit_signal("force_right", 0)
		p_node.emit_signal("force_left", 0)
		#####################################
	if Input.is_action_pressed("ui_accept") :
		emit_signal("play_attack_anim","AttackAnim")


# Emit no input signal only when no direction is pressed
	if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		p_node.emit_signal("no_input")

