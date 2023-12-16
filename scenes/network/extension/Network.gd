extends Node
class_name NetworkNode

var Port = 6503
var Address = "127.0.0.1"

enum{
	PING,
	PINGSERVER,
	PLAYERCONNECT,
	PLAYERDISCONNECT,
	REQUESTFORPLAYERDATA,
	INITPLAYERDATA,
	PLAYERINPUTKEY,
	GAMESTATESNAPSHOT,
	UPDATEPLAYERPOSITION,
}

var MsgDetailedDescription = {
	PING:"Ping...",
	PINGSERVER:"Ping From Server...",
	PLAYERCONNECT:"Player Connecting",
	PLAYERDISCONNECT:"Player Disconecting",
	REQUESTFORPLAYERDATA:"Requesting Player Data/Info",
	INITPLAYERDATA:"Intantiating Player Object",
	PLAYERINPUTKEY:"Player Input Key",
	GAMESTATESNAPSHOT:"Game State Snapshot",
	UPDATEPLAYERPOSITION:"Updating Single Player Position",
}
