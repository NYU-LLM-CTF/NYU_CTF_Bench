extends KinematicBody2D
signal health_updated(health)
signal damage()
signal dead()

var dead = false
var cd = false
var walk_speed = 450.0
var move_input
var attacking = false
var animdir = 1
var vertmi = Vector2()
var velocity = Vector2()
onready var invulerability_timer = $InvulnerabilityTimer
onready var animatedsprite = $"StateMachine/AnimatedSprite2D"
onready var health = max_health
export (float) var max_health = 100 setget _set_health
var bullet = preload("res://Scenes/Bullet.tscn")

func _apply_movement():
	velocity = move_and_slide(velocity, Vector2(0,-1))
	velocity = velocity.normalized() * walk_speed

func _handle_move_input():
	if !dead:
		move_input = -int(Input.is_action_pressed('ui_left'))+int(Input.is_action_pressed("ui_right"))
		if move_input != 0:
			animatedsprite.flip_h = move_input != 1
			velocity.x = lerp(velocity.x, walk_speed * move_input,0.1)
		else:
			velocity.x = 0
		vertmi = -int(Input.is_action_pressed("ui_up")) +int(Input.is_action_pressed("ui_down"))
		if vertmi != 0:
			if move_input == 0:
				if vertmi == 1:
					animdir = 2
				else:
					animdir = 3
			else:
				animdir = 1
			velocity.y = lerp(velocity.y, walk_speed * vertmi, 0.1)
		else:
			velocity.y = 0
		

func death():
	velocity.x = 0
	velocity.y = 0
	dead = true
	$DeathTimer.start()
	emit_signal("dead")

func damage(amount):
	if invulerability_timer.is_stopped():
		emit_signal("damage")
		invulerability_timer.start()
		_set_health(health - amount)
		
		

func _set_health(value):
	$Hit.play()
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			death()


func attack():
	if ! dead && !cd:
		$Shoot.play()
		cd = true
		var bul = bullet.instance()
		get_parent().add_child(bul)
		bul.global_position = global_position
		bul.target = "enemy"
		var dir  = (get_global_mouse_position() - global_position).normalized()
		bul.global_rotation = dir.angle() + PI / 2.0
		bul.direction = dir
		$AttackTimer.start()


func _on_DeathTimer_timeout():
	get_tree().reload_current_scene()


func _on_AttackTimer_timeout():
	cd = false

