extends Node2D
class_name MainCon

enum {
	MAINMENU,
	GAMEWORLD
}	
var RoomLoaded = {
	MAINMENU:preload("res://scenes/rooms/main_menu/rm_main_menu.tscn"),
	GAMEWORLD:preload("res://scenes/rooms/gameworld/gameworld.tscn")
}
var CurrentRoom:Room

func _ready():
	_change_room(MAINMENU)

func _change_room(RoomIndex):
	if CurrentRoom!=null:
		remove_child(CurrentRoom)
		CurrentRoom.queue_free()
	_bring_room(RoomIndex)
func _bring_room(RoomIndex):
	CurrentRoom = RoomLoaded[RoomIndex].instantiate()
	CurrentRoom.maincon = self
	add_child(CurrentRoom)
