extends Node2D

export var MaxHP = 30
export var acceleration = 400.0
export var max_speed = 800.0
export var friction = 0
var knockback_duration = 0.3
var knockback_timer = 0.0
var isknockback = false
# Variables for AI behavior
var charge_speed = 600  
var zigzag_pattern = false
var charging = false
var random_charge_threshold = 0.01  

var retreatstress =0 #Stress
onready var Text = get_node("PhysicComponent/RichTextLabel") #PlaceHolder
onready var spit = get_node("PhysicComponent/Sprite") #PlaceHolder
# Player reference and AI state
onready var player
var direction_to_player = Vector2.ZERO
var input_vector = Vector2.ZERO
onready var p_node = get_node("PhysicComponent")
onready var h_node = get_node("HealthComponent")

func _ready(): #Initialize
	add_to_group("enemies")
	player = get_node("/root/MainScene/PlayerNode/PhysicComponent")
	p_node.on_set_variable(acceleration,max_speed,friction)
	h_node._setMaxHP(MaxHP)


func _physics_process(delta):
	#Debug Text
	Text.text = "Charging: " + str(charging) +" Stress: " + str(retreatstress)+ "\nHP :" + str(h_node._returnHealthPercen()*100) +"%"+ "\nInput Vector :" + str(input_vector)
	#Fuzzy Skibidi Logic
	if h_node._returnHealthPercen() > .8 :
		retreatstress = 0.1
	elif h_node._returnHealthPercen() > .4 :
		retreatstress =+ .4
	elif h_node._returnHealthPercen() <= .4:
		retreatstress =+ .6
	retreatstress = clamp(retreatstress, 0, 1) #clamp stress between 0-100%
	charging = retreatstress < 0.5
 
	var direction = (player.global_position - p_node.global_position).normalized() #get which direction input shold be Example (0,1) is go right
	input_vector = direction * (charge_speed if charging else acceleration) 
	_send_movement_input(input_vector)
	_animUpdate(input_vector)#update animation


func _send_movement_input(input_vector):
	p_node._on_override_input(input_vector)
	if input_vector == Vector2.ZERO:
		p_node.emit_signal("no_input")

func _animUpdate(input_vector): #Placeholder
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
func _on_HealthComponent_died():
	queue_free() #Die ,Mortis, ตาย
	pass 

func _health_update(type : String,amount ) : # Not working here yet
	h_node.emit_signal("update_health",type,amount)
	if type == 'damage' : #Knockback
		isknockback = true
	