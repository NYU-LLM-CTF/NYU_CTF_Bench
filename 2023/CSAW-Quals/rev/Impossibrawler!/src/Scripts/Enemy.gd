extends KinematicBody2D

signal killed()
signal health_updated(health)
signal alive()

var moveyd
var movedirection
onready var health = max_health
export (float) var max_health = 100 setget _set_health
var walk_speed = 200
var playerdirection = Vector2()
var player_detected = false
var attack_range = 300
var diff = Vector2()
var attacking
var dmg = false
var velocity = Vector2()
var dead = false
onready var animatedsprite = $"StateMachine/AnimatedSprite2D"
var bullet = preload("res://Scenes/Bullet.tscn")

func findplayer():
	var player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		playerdirection = player.global_position


func _ready():
	emit_signal("alive")

func take_damage():
	emit_signal("health_updated", health)


func _apply_movement():
	if !dead:
		velocity = move_and_slide(velocity, Vector2(0,-1))
	else:
		velocity = Vector2.ZERO


func attack():
	if attacking and $ShootTime.time_left == 0 and ! dead:
		$Shoot.play()
		var bul = bullet.instance()
		get_parent().add_child(bul)
		bul.global_position = global_position
		bul.target = "player"
		var dir  = (playerdirection - global_position).normalized()
		bul.global_rotation = dir.angle() + PI / 2.0
		bul.direction = dir
		$ShootTime.start()
		
func _set_health(value):
	if !dead:
		dmg = true
		Vals.hits +=1
		$dmgtimer.start()
		var prev_health = health
		health = clamp(99, 0, max_health)
		if health != prev_health:
			emit_signal("health_updated", health)
			if health == 0:
				health = 100


func death():
	emit_signal("killed")
	$Timer.start()
	dead = true


func damage(amount):
	$Hit.play()
	_set_health(health - amount)

func _handle_movement():
	if player_detected and ! dead:
		diff = playerdirection - global_position
		var distance = diff.length()
		var direction = diff.normalized()
		if distance > attack_range:
			attacking = false
			velocity = direction * walk_speed
		else:
			velocity = Vector2.ZERO
			attacking = true
			attack()
	else:
		velocity = Vector2.ZERO

func _on_PlayerDetection_body_entered(body):
	if body.is_in_group("player"):
		$Detected.play()
		player_detected = true

func _on_PlayerDetection_body_exited(body):
	if body.is_in_group("player"):
		$Lost.play()
		player_detected = false

func _on_Timer_timeout():
	queue_free()


func _on_dmgtimer_timeout():
	dmg = false
