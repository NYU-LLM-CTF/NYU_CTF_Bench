extends Control

@onready var health_bar = $HealthBar
@onready var hbarunder = $HbarUnder


func _on_Player_health_updated(health):
	health_bar.value = health
	


