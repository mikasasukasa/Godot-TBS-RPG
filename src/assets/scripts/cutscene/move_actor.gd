extends Node

export(NodePath) var actor
export(Vector2) var position
export(bool) var shouldWaitArrival

var manager
var actorNode

func start(_manager):
	print(get_name(), " has started!")
	manager = _manager
	
	actorNode = get_node(actor)
	actorNode.find_path_to(position)
	
	if shouldWaitArrival:
		set_process(true)
	else:
		end()

func end():
	print(get_name(), " has ended!")
	manager.content.pop_front()
	manager.work()
	queue_free()

func _process(dt):
	if !actorNode.should_move():
		end()