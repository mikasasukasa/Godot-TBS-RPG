extends Node

export var frames = 0
var manager

func start(_manager):
	print(get_name(), " has started!")
	manager = _manager
	set_process(true)

func end():
	print(get_name(), " has ended!")
	manager.content.pop_front()
	manager.work()
	queue_free()

func _process(dt):
	if frames <= 0:
		end()
	else:
		frames -= 1