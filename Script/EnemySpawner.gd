extends Node2D

onready var main = get_node("/root/MainScene")
var enemy_1 := preload("res://Scene/Enemy/Enemy_rework.tscn")  # Old movement
var enemy_2 := preload("res://Scene/Enemy/Enemy_rework2.tscn")  # New movement
var spawn_points := []
export var max_enemies = 5  # Maximum number of enemies to spawn
export var spawn_interval = 20000.0  # Time in seconds between spawns
var enemies_spawned = 0  # Counter for spawned enemies

func _ready():
	for i in get_children():
		if i is Position2D:
			spawn_points.append(i)
	
	# Start spawning enemies
	$Timer.wait_time = spawn_interval
	$Timer.start()

func _on_Timer_timeout():
	if enemies_spawned < max_enemies:
		# Pick a random spawn point
		var spawn = spawn_points[randi() % spawn_points.size()]

		# Randomly choose between old and new movement enemies
		var enemy_scene
		if randi() % 2 == 0:
			enemy_scene = enemy_1
		else:
			enemy_scene = enemy_2

		var enemy = enemy_scene.instance()

		# Set enemy position and add it to the scene
		enemy.position = spawn.position
		enemy.add_to_group("enemies")
		main.add_child(enemy)

		# Increment the spawned enemy counter
		enemies_spawned += 1

		# Stop spawning if the maximum number is reached
		if enemies_spawned >= max_enemies:
			$Timer.stop()
