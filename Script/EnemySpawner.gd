extends Node2D

onready var main = get_node("/root/MainScene")
var enemy1_scene := preload("res://Scene/Enemy.tscn")
var spawn_points := []
var max_enemies = 5  # Maximum number of enemies to spawn
var spawn_interval = 2.0  # Time in seconds between spawns
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
		# Pick random spawn point
		var spawn = spawn_points[randi() % spawn_points.size()]
		# Spawn enemy
		var enemy = enemy1_scene.instance()
		enemy.position = spawn.position
		enemy.add_to_group("enemies")
		main.add_child(enemy)

		enemies_spawned += 1  # Increment the spawned enemy counter

		# Stop spawning if the maximum number is reached
		if enemies_spawned >= max_enemies:
			$Timer.stop()
