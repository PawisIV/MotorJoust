extends AnimatedSprite

# Function to handle signal from PlayerNode


func _on_PlayerNode_play_animation(anim_name,flip):
		play(anim_name)
		flip_h = flip
