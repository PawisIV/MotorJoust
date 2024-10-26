extends Node
var MaxHP
var CurrentHP
signal died
signal update_health(type , amount)  
func _ready():
	pass # Replace with function body.

func _setMaxHP(arg1):
	MaxHP = arg1
	CurrentHP = MaxHP

func _returnHealthPercen()->float: 
	return float(CurrentHP) / float(MaxHP)




func _on_HealthComponent_update_health(type : String, amount):
	if type == 'damage' :
		CurrentHP -= amount
		print("hit")
		if CurrentHP <= 0:
			emit_signal("died")
	elif type == 'heal' :
		CurrentHP += amount 
	pass # Replace with function body.
