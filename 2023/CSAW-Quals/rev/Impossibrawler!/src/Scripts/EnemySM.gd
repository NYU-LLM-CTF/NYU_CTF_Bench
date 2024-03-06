extends 'res://Scripts/StateMachine.gd'

func _ready():
	add_state("idle")
	add_state("chase")
	add_state("dead")
	add_state("attack")
	add_state("damage")
	call_deferred("set_state",states.idle)

func _state_logic(delta):
	parent._handle_movement()
	parent._apply_movement()
	parent.findplayer()

func _get_transition(delta):
	match state:
		states.idle:
			if parent.dead:
				return states.dead
			elif parent.dmg:
				return states.damage
			elif parent.player_detected:
				return states.chase
		states.chase:
			if parent.dead:
				return states.dead
			elif parent.dmg:
				return states.damage
			elif ! parent.player_detected:
				return states.idle
			elif parent.attacking:
				return states.attack
		states.attack:
			if parent.dead:
				return states.dead
			elif parent.dmg:
				return states.damage
			elif !parent.player_detected :
				return states.idle
			elif parent.player_detected && !parent.attacking:
				return states.chase
		states.damage:
			if parent.dead:
				return states.dead
			elif !parent.dmg:
				return states.idle
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			$AnimatedSprite2D.play("Idle")
		states.dead:
			$AnimatedSprite2D.play("Death")
		states.damage:
			$AnimatedSprite2D.play("Damage")
