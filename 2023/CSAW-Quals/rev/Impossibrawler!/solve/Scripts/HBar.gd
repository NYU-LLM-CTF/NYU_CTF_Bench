extends Control

onready var health_bar = $HealthBar
onready var update_tween = $UpdateTween
onready var hbarunder = $HbarUnder


func _on_Player_health_updated(health):
	update_tween.interpolate_property(hbarunder, "value", hbarunder.value, health, 0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.1)
	update_tween.start()
	health_bar.value = health
	


