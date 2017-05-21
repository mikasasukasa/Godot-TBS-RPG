extends Node

var manager
export(NodePath) var actor
export(Vector2) var position

func start(_manager):
	manager = _manager
	
	get_node(actor).set_pos(manager.scene.map_to_world_fixed(position))
	end()

func end():
	#print(get_name(), " has ended!")
	manager.contentNow.pop_front()
	manager.content.pop_front()
	manager.work()
	queue_free()

func skip():
	queue_free()
	end()
	
func should_wait_end():
	return false