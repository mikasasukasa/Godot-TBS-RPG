extends Node

export(NodePath) var actor
export(bool) var waitEnd
var manager

var _actor

func start(_manager):
	print(get_name(), " has started!")
	manager = _manager
	
	_actor = get_node(actor)
	_actor.set_pos(_actor.scene.map_to_world_fixed(_actor.scene.get_terrain().world_to_map(_actor.get_pos())))
	
	
	if waitEnd:
		set_process(true)
	else:
		#queue_free()
		end()

func end():
	print(get_name(), " has ended!")
	manager.contentNow.pop_front()
	manager.content.pop_front()
	manager.work()

func _process(dt):
	var o = _actor.get_opacity()
	
	if o >= 1.0:
		queue_free()
		end()
	else:
		_actor.set_opacity(o + 0.1)

func skip():
	_actor.set_opacity(1.0)
	queue_free()
	end()

func should_wait_end():
	return waitEnd