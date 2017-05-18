extends Node

export var dialogue = ""
var manager

func start(_manager):
	print(get_name(), " has started!")
	manager = _manager
	
	#var d = load("res://assets/prefabs/dialogues/" + dialogue + ".dialogue.tscn")
	var d = preload("res://assets/prefabs/dialogue_box.prefab.tscn")
	
	if d:
		var e = d.instance()
		manager.scene.add_child(e)
		e.start(self, dialogue)
	else:
		print(get_name(), " couldn't find such dialogue entry.")

func end():
	print(get_name(), " has ended!")
	manager.content.pop_front()
	manager.work()
	queue_free()