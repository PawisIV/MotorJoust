extends Area2D

var attack_damage = 10
var is_attacking = false
var attack_duration = 0.3  # Time window for hit detection

signal attack_finished

# Called when the node enters the scene tree for the first time
func _ready():
	add_to_group("attacks")
	monitoring = false
	connect("body_entered", self, "_on_body_entered")

# Trigger attack with this function
func start_attack():
	is_attacking = true
	monitoring = true  # Enable hit detection
	yield(get_tree().create_timer(attack_duration), "timeout")  # Wait for attack duration
	end_attack()

func end_attack():
	is_attacking = false
	monitoring = false  # Disable hit detection
	emit_signal("attack_finished")

# Handle when an enemy enters the hitbox
func _on_body_entered(body):
	if is_attacking and body.is_in_group("enemies"):  
		var enemy = body.get_parent()
		if enemy.has_method("_health_update"):
			enemy._health_update('damage',attack_damage)
			#print ("Hit")  
