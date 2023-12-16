extends Room


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode==KEY_UP:
				# Start Server
				maincon._bring_room(maincon.GAMEWORLD)
				maincon.remove_child(self)
				global.NetworkCon = load("res://scenes/network/server_con.gd").new()
				maincon.CurrentRoom.add_child(global.NetworkCon)
				queue_free()
			if event.keycode==KEY_DOWN:
				# Join Server
				maincon._bring_room(maincon.GAMEWORLD)
				maincon.remove_child(self)
				global.NetworkCon = load("res://scenes/network/client_con.gd").new()
				maincon.CurrentRoom.add_child(global.NetworkCon)
				queue_free()
