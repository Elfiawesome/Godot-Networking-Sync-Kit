extends NetworkConClass
class_name ClientCon



func _ready():
	network = load("res://scenes/network/extension/NetworkClient.gd").new()
	add_child(network)

	network._JoinServer()
	network.Connect.connect(_Client_Player_Connected)
	network.ReceiveData.connect(_Client_Player_ReceiveData)
	
	add_child(PingTimer)
	PingTimer.wait_time = 1.0
	PingTimer.start()
	PingTimer.timeout.connect(_on_PingTimer)

func _on_PingTimer():
	network.SendData([network.PING,[]])
	TimeSincePing = Time.get_ticks_msec()

func _Client_Player_Connected():
	# You can use this if you want to send a data straight to the server to INITPLAYERDATA
	# However in this case, I asked the server to ask the connecting client for INITPLAYERDATA
	# Mostly do that so that the server can be in control of connections fully
	pass
func _Client_Player_ReceiveData(message):
	var cmd = message[0]
	var buffer = message[1]
	match(cmd):
		network.PING:
			Ping = (Time.get_ticks_msec() - TimeSincePing)/2
			socket_to_instanceid[mysocket].Ping = Ping
			TimeSincePing = 0
		network.PLAYERCONNECT:
			pass
		network.PLAYERDISCONNECT:# Handle when my fellow client has disconnected
			socket_to_instanceid[buffer[0]].queue_free()
			socketlist.erase(buffer[0])
			socket_to_instanceid.erase(buffer[0])
		network.REQUESTFORPLAYERDATA:# When asked by server to give data (Actually can give mannualy by me)
			var socket = buffer[0]
			mysocket = socket
			var playercon = _create_player(socket)
			socketlist.push_back(socket)
			socket_to_instanceid[socket] = playercon
			playercon._set_player_data({
				"Name":"Client",
				"Team":randi_range(1,2),
				"Title":"Client man"
			})
			playercon.mysocket = mysocket
			playercon.IsLocal = true
			# Update team comp to add myself inside it
			# tell server my data
			network.SendData([network.REQUESTFORPLAYERDATA,[playercon._get_player_data()]])
		network.INITPLAYERDATA:# Asked to create a player
			var socket = buffer[0]
			var socketdata = buffer[1]
			
			var playercon:PlayerCon = _create_player(socket)
			socketlist.push_back(socket)
			socket_to_instanceid[socket] = playercon
			playercon._set_player_data(socketdata)
		network.PLAYERINPUTKEY:
			_PlayerInputKey(buffer)
		network.GAMESTATESNAPSHOT:
			pass
			for sock in buffer:
				if socketlist.has(sock):
					if socket_to_instanceid[sock].position != buffer[sock][0]:
						print("Difference in position: "+str(
							socket_to_instanceid[sock].position-buffer[sock][0]
						))
					socket_to_instanceid[sock].position = buffer[sock][0]
		network.UPDATEPLAYERPOSITION:
			_UpdatePlayerPosition(buffer)
