extends AnimationPlayer
onready var attacksprite = get_node("../AttackSprite")  
func _ready() :
	attacksprite.visible = false
	playback_speed = 2
func _on_PlayerNode_play_attack_anim(anim_name):
	play(anim_name)

func _on_AttackAnimHandler_animation_finished(anim_name):
	pass # Replace with function body.



