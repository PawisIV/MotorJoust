extends Node2D

onready var main = get_node("/root/MainScene")
var enemy1_scene := preload("res://Scene/Enemy.tscn")
var spawn_points := []

func _ready():
	for i in get_children():
		if i is Position2D:
			spawn_points.append(i)

func _on_Timer_timeout():
	#pick random spawnpoint
	var spawn = spawn_points[randi() % spawn_points.size()]
	#spawn enemy
	var enemy = enemy1_scene.instance()
	enemy.position = spawn.position
	main.add_child(enemy)
