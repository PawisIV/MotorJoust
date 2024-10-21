extends AnimationPlayer
func _ready() :
	playback_speed = 2
# Function to handle signal from PlayerNode
func _on_PlayerNode_play_animation(anim_name, flip):
	# Play the animation in the AnimationPlayer
	play(anim_name)
	# Flip the sprite manually by adjusting the scale
	var sprite = get_node("../PlayerSprite") 

	if flip:
		sprite.scale.x = -1  # Flip the sprite horizontally
	else:
		sprite.scale.x = 1  # Reset to normal scale


