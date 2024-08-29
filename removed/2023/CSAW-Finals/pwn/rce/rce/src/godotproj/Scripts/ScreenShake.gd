extends Node
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT
var amplitude = 0

@onready var camera = get_parent()

func start(duration = 0.2, Frequency = 20, amplitude = 20):
	self.amplitude = amplitude
	$Duration.wait_time = duration
	$Frequency.wait_time = 1/ float(Frequency)
	$Duration.start()
	$Frequency.start()
	
func _new_shake():
	var rand = Vector2()
	rand.x = randf_range(-amplitude,amplitude)
	rand.y = randf_range(-amplitude,amplitude)
	
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

func _reset():
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()


func _on_Frequency_timeout():
	_new_shake()


func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
