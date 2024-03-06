extends Node2D

var totalenemies = 0
var rng = RandomNumberGenerator.new()
var enemies_left = 0


func _process(delta):
	var mousepos = get_global_mouse_position()
	get_node("Crosshair").position = mousepos

	if enemies_left == 0:
		rng.seed = int(Vals.sd)
		var fbytes = rng.randf()
		Vals.sd = fbytes 
		fbytes = str(fbytes)
		var flg = fbytes.to_ascii().hex_encode()
		$CanvasLayer/Label.set_text("csawctf{" + flg + "}")

func _on_Enemy_killed():
	enemies_left -=1 

func _on_Enemy_alive():
	totalenemies+=1
	enemies_left +=1

func _ready():

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


