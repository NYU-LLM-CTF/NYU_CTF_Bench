extends Camera2D



func _on_Player_damage():
	$ScreenShake.start()
