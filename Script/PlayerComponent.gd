extends Node2D
export var MaxHP = 100
export var acceleration = 0.0
export var max_speed = 800.0
export var friction = 0
#Reference to the physics component
onready var p_node = get_node("PhysicComponent")
onready var h_node = get_node("HealthComponent")
onready var attack_hitbox = $PhysicComponent/Area2D
var attack_cooldown = 0.5
var attack_timer = 0.0
#onready var a_node = get_node("PhysicComponent/AnimationPlayer")
signal play_animation(anim_name,flip)
signal play_attack_anim(anim_name)
func _ready():
	attack_hitbox.connect("attack_finished", self, "_on_attack_finished")
	p_node.on_set_variable(acceleration,max_speed,friction)
	h_node._setMaxHP(MaxHP)


func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	if attack_timer > 0 :
		attack_timer -= _delta
	if Input.is_action_pressed("ui_up"):  # W key
		input_vector.y -= 1
	if Input.is_action_pressed("ui_down"):  # S key
		input_vector.y += 1
	if Input.is_action_pressed("ui_left"):  # A key
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):  # D key
		input_vector.x += 1
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
	p_node._on_override_input(input_vector)
	anim_update()
	if Input.is_action_pressed("ui_accept") and attack_timer <= 0:
		attack_timer = attack_cooldown
		attack_hitbox.start_attack()
		emit_signal("play_attack_anim","AttackAnim")

	if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		p_node.emit_signal("no_input")

func anim_update():
	if  Input.is_action_pressed("ui_up") :
		if Input.is_action_pressed("ui_right") :
			emit_signal("play_animation","PlayerUpRight",false)
		elif Input.is_action_pressed("ui_left") :
			emit_signal("play_animation","PlayerUpRight",true)
		else :
			emit_signal("play_animation","PlayerUp",true)
	if  Input.is_action_pressed("ui_down") :
		if Input.is_action_pressed("ui_right") :
			emit_signal("play_animation","PlayerDownRight",false)
		elif Input.is_action_pressed("ui_left") :
			emit_signal("play_animation","PlayerDownRight",true)
		else :
			emit_signal("play_animation","PlayerDown",true)
	if  Input.is_action_pressed("ui_right") :
		if Input.is_action_pressed("ui_down") :
			emit_signal("play_animation","PlayerDownRight",false)
		elif Input.is_action_pressed("ui_up") :
			emit_signal("play_animation","PlayerUpRight",false)
		else :
			emit_signal("play_animation","PlayerRight",false)
	if  Input.is_action_pressed("ui_left") :
		if Input.is_action_pressed("ui_down") :
			emit_signal("play_animation","PlayerDownRight",true)
		elif Input.is_action_pressed("ui_up") :
			emit_signal("play_animation","PlayerUpRight",true)
		else :
			emit_signal("play_animation","PlayerRight",true)

func _on_HealthComponent_died():
	queue_free()
	pass # Replace with function body.

func _on_attack_finished():
	print("Attack finished!")
