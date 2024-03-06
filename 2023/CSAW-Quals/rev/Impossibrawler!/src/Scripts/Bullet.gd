extends Area2D

class_name Bullet

var speed = 800
var direction = Vector2.RIGHT
var target 

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if target == "player":
			body.damage(50)
			queue_free()
	elif body.is_in_group("enemy"):
		if target == "enemy":
			body.damage(Vals.playerdmg)
			queue_free()
	elif body.is_in_group("tilemap"):
		queue_free()


func _on_Timer_timeout():
	queue_free()


func _process(delta):
	translate(direction*speed*delta)


func _ready():
	$Timer.start()
