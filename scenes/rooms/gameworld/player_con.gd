extends Node2D
class_name PlayerCon
# Network Variables
var mysocket = 0
var IsLocal = false
var IsInitialized = false
var Ping:float = 0.0
var PlayerInfo = {
	"Name":"Default Name",
	"Team":0,
	"Title":"Default Title"
}
enum {
	GAMERIGHT,
	GAMELEFT,
	GAMEUP,
	GAMEDOWN,
}
var KeyPressedMap = {
	GAMERIGHT:false,
	GAMELEFT:false,
	GAMEUP:false,
	GAMEDOWN:false,
}
@onready var NameLabel = $Sprite2D/MarginContainer/Control/NameLabel
@onready var DebugPosLabel = $Sprite2D/MarginContainer/Control/DebugPos

func _set_player_data(datainfo:Dictionary):
	PlayerInfo = datainfo
	IsInitialized = true
	if datainfo.has("Name"):
		NameLabel.text = datainfo["Name"]
func _get_player_data():
	return PlayerInfo

var spd = 200
func _input(event:InputEvent):
	pass

func _process(delta):
	if IsLocal:
		if Input.is_action_just_pressed("game_right"):
			_movement_key(GAMERIGHT,true)
		if Input.is_action_just_released("game_right"):
			_movement_key(GAMERIGHT,false)
		if Input.is_action_just_pressed("game_left"):
			_movement_key(GAMELEFT,true)
		if Input.is_action_just_released("game_left"):
			_movement_key(GAMELEFT,false)
		if Input.is_action_just_pressed("game_up"):
			_movement_key(GAMEUP,true)
		if Input.is_action_just_released("game_up"):
			_movement_key(GAMEUP,false)
		if Input.is_action_just_pressed("game_down"):
			_movement_key(GAMEDOWN,true)
		if Input.is_action_just_released("game_down"):
			_movement_key(GAMEDOWN,false)
	
	if KeyPressedMap[GAMERIGHT]:
		position.x += spd*delta
	if KeyPressedMap[GAMELEFT]:
		position.x -= spd*delta
	if KeyPressedMap[GAMEUP]:
		position.y -= spd*delta
	if KeyPressedMap[GAMEDOWN]:
		position.y += spd*delta
	
	DebugPosLabel.text = (
		#str(position) + "\n" + 
		str(Ping)
	)

func _movement_key(keyindex:int, pressed:bool):
	KeyPressedMap[keyindex] = pressed
	if global.NetworkCon.IsServer:
		global.NetworkCon._svrPlayerInputKey(mysocket, [mysocket, keyindex, KeyPressedMap[keyindex]])
	else:
		global.NetworkCon.network.SendData([NetworkNode.PLAYERINPUTKEY,[mysocket, keyindex, pressed]])
