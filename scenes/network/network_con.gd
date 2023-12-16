extends Node
class_name NetworkConClass

#Network Variables
var network:NetworkNode
var socket_to_instanceid = {}
var socketlist = []
var mysocket = -1
var IsServer = false
var Ping:float = 0
var PingTimer:Timer = Timer.new()
var TimeSincePing:float = 0
# Game variables
var GameSettings = {"Gamemode":0,"TeamComposition":{}}
var Turnstage:Array = []
var Turn:int = 0
enum {
	PLAYERTURN = 0,
	ATTACKINGTURN
}
var GameStage:int = PLAYERTURN
var UnitIdentifier = 0
var SpellIdentifier = 0
var HandCardIndentifier = 0

func _on_PingTimer():
	pass

func _create_player(socket:int) -> PlayerCon:
	var _inst:PlayerCon = load("res://scenes/rooms/gameworld/player_con.tscn").instantiate()
	_inst.mysocket = socket
	add_child(_inst)
	return _inst

func _svrPlayerInputKey(socket:int, buffer:Array):
	_PlayerInputKey(buffer)
	for sock in socketlist:
		if sock!=socket:
			network.SendData(sock,[network.PLAYERINPUTKEY,buffer])
func _PlayerInputKey(buffer:Array):
	socket_to_instanceid[buffer[0]].KeyPressedMap[buffer[1]] = buffer[2]


func _svrUpdatePlayerPosition(buffer:Array):
	# Theres none here coz the server will NEVER get a command form clients to update SERVER Position :0
	pass
func _UpdatePlayerPosition(buffer:Array):
	#UPDATEPLAYERPOSITION
	if socket_to_instanceid[buffer[0]].position!=buffer[1]:
		print("Position Disrepency Found for ["+str(buffer[0])+"]: "+str(socket_to_instanceid[buffer[0]].position-buffer[1]))
	socket_to_instanceid[buffer[0]].position = buffer[1]
