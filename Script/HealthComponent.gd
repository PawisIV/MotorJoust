extends Node
var MaxHP
var CurrentHP
signal died
func _ready():
	pass # Replace with function body.

func _setMaxHP(arg1):
	MaxHP = arg1
	CurrentHP = MaxHP

func _UpdateHealth(type : String,amount):
	if type == 'damage' :
		CurrentHP -= amount
		if CurrentHP == 0:
			emit_signal("died")
	elif type == 'heal' :
		CurrentHP += amount 

func _returnHealthPercen()->float: 
	return CurrentHP/MaxHP
