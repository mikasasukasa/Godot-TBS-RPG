extends Node

export var dialogue = ""
var manager
var dialogueObj

func start(_manager):
	#print(get_name(), " has started!")
	manager = _manager
	
	#var d = load("res://assets/prefabs/dialogues/" + dialogue + ".dialogue.tscn")
	var d = preload("res://assets/prefabs/dialogue_box.prefab.tscn")
	
	dialogueObj = d.instance()
	dialogueObj.start(self, dialogue)
	manager.scene.add_child(dialogueObj)
#	else:
#		print(get_name(), " couldn't find such dialogue entry.")

func skip():
	dialogueObj.queue_free()
	end()

func end():
	#print(get_name(), " has ended!")
	manager.contentNow.pop_front()
	manager.content.pop_front()
	manager.work()
	queue_free()

func should_wait_end():
	return true