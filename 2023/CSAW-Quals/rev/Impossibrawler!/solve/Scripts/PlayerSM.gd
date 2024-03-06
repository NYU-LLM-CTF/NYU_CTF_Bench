extends 'res://Scripts/StateMachine.gd'

var walking = false
func _ready():
	add_state("idle")
	add_state("dead")
	add_state("walk")
	add_state("attack")
	call_deferred("set_state",states.idle)

func _input(event):
	if !parent.dead:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				parent.attack()

func _state_logic(delta):
	parent._handle_move_input()
	parent._apply_movement()
	if walking:
		if parent.animdir == 1:
			$AnimatedSprite2D.play("WalkSide")
		elif parent.animdir == 2:
			$AnimatedSprite2D.play("WalkDown")
		elif parent.animdir == 3:
			$AnimatedSprite2D.play("WalkUp")

func _get_transition(delta):
	match state:
		states.idle:
			if parent.dead:
				return states.dead
			elif abs(parent.velocity.x) > 10 or abs(parent.velocity.y) > 10:
				return states.walk
		states.walk:
			if parent.dead:
				return states.dead
			elif abs(parent.velocity.x) < 10 and abs(parent.velocity.y) < 10:
				return states.idle
	return null



func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			walking = false
			$AnimatedSprite2D.play("Idle")
		states.walk:
			walking = true
				
		states.dead:
			walking = false
			$AnimatedSprite2D.play("Death")


