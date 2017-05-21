extends Node2D

var Marker = preload("res://assets/prefabs/move_marker.prefab.tscn")

onready var manager = get_parent()
var frame = 0
var time = 12
var actor
var from

func _ready():
	print("Move state started, my actor: ", actor.name, ". Move: ", actor.move)
	
	var terrain = manager.get_scene().get_terrain()
	var source = terrain.world_to_map(actor.get_pos())
	var actors = manager.scene.get_actors()
	
	for a in actors:
		if a.group != actor.group:
			manager.get_scene().get_mstar().forbidv(terrain.world_to_map(a.get_pos()))
	
#	for x in range(max(1, source.x - actor.move), source.x + actor.move + 1):
#		for y in range(max(1, source.y - actor.move), source.y + actor.move + 1):
#			var pos = Vector2(x, y)
#			
#			#if pos == source:
#			#	continue
#			
#			#if !is_free(actors, terrain, source):
#			#	continue
#			
#			var difference = pos - source
#			if abs(difference.x) + abs(difference.y) > actor.move:
#				continue
#			
#			var path = manager.mstar.find_path_v(source, pos)
#			if path.size() < 1 || path.size() > actor.move:
#				continue
#			
#			add_marker_at(pos)
	
	for m in actor.get_movable_panels():
		add_marker_at(m)
	
	for m in get_children():
		for a in actors:
			if a != actor:
				if terrain.world_to_map(m.get_pos()) == terrain.world_to_map(a.get_pos()):
					m.queue_free()
	
	for a in actors:
		if a.group != actor.group:
			manager.scene.get_mstar().freecv(terrain.world_to_map(a.get_pos()))
	
	manager.get_cursor().activate(true)
	set_process_input(true)
	set_process(true)

func add_marker_at(pos):
	var marker
	marker = Marker.instance()
	add_child(marker)
	marker.set_pos(manager.map_to_world_fixed(pos))

func _process(dt):
#	if time <= 0:
#		if frame < 4:
#			frame += 1
#		else:
#			frame = 0
#		
#		for m in get_children():
#			m.set_frame(frame)
#		
#		time += 5
#	else:
#		time -= 1
	pass

func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		finish(true)
	elif ev.is_action_pressed("ui_accept"):
		#print("AIUSHDIA")
		
		start()

func finish(_move_back):
	if _move_back:
		manager.get_cursor().set_pos(actor.get_pos())
	manager.get_cursor().activate(false)
	#manager.activate(true)
	from.activate(true)
	from.set_hidden(false)
	queue_free()

func start():
	var cursor = manager.get_cursor()
	var terrain = manager.get_scene().get_terrain()
	var actorPos = terrain.world_to_map(actor.get_pos())
	var cursorPos = terrain.world_to_map(cursor.get_pos())
	
	for m in get_children():
		if terrain.world_to_map(m.get_pos()) == cursorPos:
			actor.find_path_to(cursorPos)
			actor.state += 1
			finish(false)
			get_tree().set_input_as_handled()
			break

func is_free(list, terrain, source):
	for A in list:
		var pos = terrain.world_to_map(A.get_pos())
		if pos == source:
			return false
	return true