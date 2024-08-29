extends Node2D

var score = 0
var rng = RandomNumberGenerator.new()
var enemy = preload("res://Scenes/Enemy.tscn")
var currentenemies = 0

func _process(delta):
	$CanvasLayer/Score.text = str(score)
	var mousepos = get_global_mouse_position()
	get_node("Crosshair").position = mousepos
	if currentenemies <=2 && $SpawnTimer.is_stopped():
		$SpawnTimer.start()

func spawn_enemy():
	var enem = enemy.instantiate()
	add_child(enem)
	var enemyinitialpos = Vector2(rng.randi_range(-500, 1500), rng.randi_range(-250,750))
	enem.global_position = enemyinitialpos
	enem.killed.connect(_on_enemy_killed)
	currentenemies +=1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	

func _on_enemy_killed():
	currentenemies -=1
	score+=1


func _on_spawn_timer_timeout():
	spawn_enemy()


func _on_player_pdead():
	Globals.currentscore = score
	get_tree().change_scene_to_file("res://Scenes/Leaderboard.tscn")
