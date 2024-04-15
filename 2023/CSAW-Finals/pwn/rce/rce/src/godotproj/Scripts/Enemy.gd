extends CharacterBody2D

signal killed()
signal health_updated(health)


var moveyd
var movedirection
@onready var health = max_health
var max_health = 100: set = _set_health
var walk_speed = 200
var playerdirection = Vector2()
var player_detected = false
var attack_range = 300
var diff = Vector2()
var attacking
var dmg = false
var dead = false
@onready var animatedsprite = $"StateMachine/AnimatedSprite2D"
var bullet = preload("res://Scenes/Bullet.tscn")

func findplayer():
	var player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		playerdirection = player.global_position


func take_damage():
	emit_signal("health_updated", health)


func _apply_movement():
	if !dead:
		set_velocity(velocity)
		set_up_direction(Vector2(0,-1))
		move_and_slide()
		velocity = velocity
	else:
		velocity = Vector2.ZERO


func attack():
	if attacking and $ShootTime.time_left == 0 and ! dead:
		$Shoot.play()
		var bul = bullet.instantiate()
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

		$dmgtimer.start()
		var prev_health = health
		health = clamp(value, 0, max_health)
		if health != prev_health:
			emit_signal("health_updated", health)



func death():
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("killed")
	$Timer.start()
	dead = true


func damage(amount):
	$Hit.play()
	_set_health(health - amount)

func _handle_movement():
	if player_detected and ! dead:
		diff = playerdirection - global_position
		if diff.x > 0:
			$StateMachine/AnimatedSprite2D.flip_h = false
		else:
			$StateMachine/AnimatedSprite2D.flip_h = true
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
		
	if health ==0 && !dead:
		death()

func _on_PlayerDetection_body_entered(body):
	if body.is_in_group("player"):
		$Detected.play()
		player_detected = true


func _on_Timer_timeout():
	queue_free()


func _on_dmgtimer_timeout():
	dmg = false
