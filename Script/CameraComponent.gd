extends Camera2D

# Adjustable parameters
export var target : NodePath
#export var smoothing_speed : float = 5.0  # Speed of the camera following the target

# Internal variables
var target_node : Node = null

func _ready():
	# Get the target node (usually the player) from the scene
	if target != null:
		target_node = get_node(target)

func _process(delta):
	# Ensure target_node exists
	if target_node:
		# Smoothly move the camera towards the player's position
		var target_position = target_node.global_position
		position = position.linear_interpolate(target_position, delta * smoothing_speed)
