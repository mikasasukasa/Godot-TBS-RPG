extends Node

export(NodePath) var actor
export(Vector2) var position
export(bool) var shouldWaitArrival

var manager
var actorNode

func start(_manager):
	#print(get_name(), " has started!")
	manager = _manager
	
	actorNode = get_node(actor)
	actorNode.find_path_to(position)
	
	if shouldWaitArrival:
		set_process(true)
	else:
		end()

func skip():
	actorNode.set_pos(manager.scene.map_to_world_fixed(position))
	actorNode.path.resize(0)
	end()

func end():
	#print(get_name(), " has ended!")
	manager.contentNow.pop_front()
	manager.content.pop_front()
	manager.work()

func _process(dt):
	if !actorNode.should_move():
		if shouldWaitArrival:
			end()
		queue_free()

func should_wait_end():
	return shouldWaitArrival