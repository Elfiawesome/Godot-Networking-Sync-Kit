extends NetworkNode
class_name NetworkClientNode

var myclientdata: client_data
var connected=false
var timeout = 5

signal ReceiveData
signal Connect

func _JoinServer():
	myclientdata = client_data.new()
	myclientdata.connection = StreamPeerTCP.new()
	myclientdata.connection.connect_to_host(Address, Port)
	myclientdata.peer = PacketPeerStream.new()
	myclientdata.peer.set_stream_peer(myclientdata.connection)
	
	myclientdata.connection.poll()
	var _status = myclientdata.connection.get_status()
	if _status == StreamPeerTCP.STATUS_CONNECTED:
		print("Succesfully Connected to "+Address+": "+str(Port))
		SuccessInConnection()
		set_process(true)
	elif _status == StreamPeerTCP.STATUS_CONNECTING:
		print("Trying to connect to "+Address+": "+str(Port)+". . . ")
		print("Timeout in "+str(timeout))
		set_process(true)
	elif _status == StreamPeerTCP.STATUS_NONE or _status == StreamPeerTCP.STATUS_ERROR:
		print("Couldn't connect to "+Address+": "+str(Port))
		FailureInConnection()

func _process(_delta):
	if myclientdata!=null:
		myclientdata.connection.poll()
		var _status=myclientdata.connection.get_status()
		if !connected: #if previously still havent connected
			if _status == StreamPeerTCP.STATUS_CONNECTED:#Finally we connected
				print("After a while, we have succesfully connected to "+Address+": "+str(Port))
				SuccessInConnection()
				return #Dont attempt to timeout
			if timeout>0:
				timeout-=0.5
				print("Timing out in "+str(timeout))
			else:
				print("Server timeout :<")
				FailureInConnection()
		
		#Check if server is available
		if _status == StreamPeerTCP.STATUS_NONE or _status == StreamPeerTCP.STATUS_ERROR:
			print("Server Disconnected??")
			set_process(false)
			FailureInConnection()
		
		#Check for incoming packets
		while (myclientdata.peer.get_available_packet_count() > 0): #get_available_bytes()>0:
			var data_received = myclientdata.peer.get_var()
			myclientdata.peer.get_reference_count()
			# print("CLIENT: received data " + str(MsgDetailedDescription[data_received[0]] +": "+ str(data_received[1])))
			emit_signal("ReceiveData",data_received)
		
#		if Input.is_action_just_pressed("ui_up"): #Test packet
#			SendData("hi server")

func FailureInConnection():
	if myclientdata!=null:
		if myclientdata.connection:
			myclientdata.connection.disconnect_from_host()
		print("We have disconnected from server")

func SuccessInConnection():
	connected=true
	emit_signal("Connect")

func SendData(message):
	myclientdata.peer.put_var(message)

