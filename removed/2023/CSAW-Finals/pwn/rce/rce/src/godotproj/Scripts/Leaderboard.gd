extends Node2D

var lbjson
var complete = false
var justentered = true
var pushavailable = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.nameentered:
		_on_confirm_pressed()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$HTTPRequest.request("http://pwn.csaw.io/leaderboard")

func _process(delta):
	if Globals.nameentered && justentered && pushavailable:
		sendscore()
		justentered = false


func _on_http_request_request_completed(result, response_code, headers, body):
	lbjson = JSON.parse_string(body.get_string_from_utf8())
	print(lbjson)
	updatelb()

	
func updatelb():
	var i = 0
	if "ok" in lbjson:
		return
	pushavailable = true
	for child in $Control/Panels.get_children():
		if i+1 <= len(lbjson):
			child.get_node("name").text = lbjson[i]["name"]
			child.get_node("score").text = str(lbjson[i]["score"])
			i+=1




func _on_timer_timeout():
	$HTTPRequest.request("http://pwn.csaw.io/leaderboard")

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")


func _on_line_edit_text_submitted(new_text):
	Globals.username = new_text

func sendscore():
	var json = JSON.stringify({"name": Globals.username, "uuid": Globals.uuid, "score": Globals.currentscore})
	var headers = ["Content-Type: application/json"]
	print('sent')
	$HTTPRequest.request("http://pwn.csaw.io/score",headers, HTTPClient.METHOD_POST, json)

func _on_confirm_pressed():
	justentered = true
	if Globals.username != "":
		Globals.nameentered = true
		$"Name enter".queue_free()



func _on_line_edit_text_changed(new_text):
	Globals.username = new_text
