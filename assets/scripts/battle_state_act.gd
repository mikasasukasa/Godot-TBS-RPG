extends Node2D

var Marker = preload("res://assets/prefabs/move_marker.prefab.tscn")

onready var manager = get_parent()
var frame = 0
var time = 12
var actor
var from

func _ready():
	print("ACT state started, my actor: ", actor.name, ". Move: ", actor.move)
	
	var terrain = manager.get_scene().get_terrain()
	var source = terrain.world_to_map(actor.get_pos())
	var actors = manager.scene.get_actors()
	
#	for a in actors:
#		if a.group != actor.group:
#			manager.mstar.forbidv(terrain.world_to_map(a.get_pos()))
	
	for x in range(max(1, source.x - actor.attackRange), source.x + actor.attackRange + 1):
		for y in range(max(1, source.y - actor.attackRange), source.y + actor.attackRange + 1):
			var pos = Vector2(x, y)
			
			if pos == source:
				continue
			
			if terrain.get_cell(x, y) < 0:
				continue
			
			#if !is_free(actors, terrain, source):
			#	continue
			
			var difference = pos - source
			if abs(difference.x) + abs(difference.y) > actor.attackRange:
				continue
			
#			var path = manager.mstar.find_path_v(source, pos)
#			if path.size() < 1 || path.size() > actor.move:
#				continue
			
			add_marker_at(pos)
	
#	for m in get_children():
#		for a in actors:
#				if terrain.world_to_map(m.get_pos()) == terrain.world_to_map(a.get_pos()):
#					m.queue_free()
	
#	for a in actors:
#		if a.group != actor.group:
#			manager.mstar.freecv(terrain.world_to_map(a.get_pos()))
	
	manager.get_cursor().activate(true)
	set_process_input(true)
	set_process(true)

func add_marker_at(pos):
	var marker
	marker = Marker.instance()
	add_child(marker)
	marker.set_pos(manager.map_to_world_fixed(pos))
	marker.set_frame(1)

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
		finish()
	elif ev.is_action_pressed("ui_accept"):
		#print("AIUSHDIA")
		
		start()

func finish():
	manager.get_cursor().set_pos(actor.get_pos())
	manager.get_cursor().activate(false)
	#manager.activate(true)
	from.activate(true)
	from.set_hidden(false)
	
	#manager.get_cursor().set_pos(actor.get_pos())
	#manager.activate(true)
	queue_free()

func start():
	var terrain = manager.get_scene().get_terrain()
	var cursor = manager.get_cursor()
	var cursorPos = terrain.world_to_map(cursor.get_pos())
	
	for m in get_children():
		
		var mp = terrain.world_to_map(m.get_pos())
		
		if mp == cursorPos:
			for a in manager.scene.get_actors():
				if terrain.world_to_map(a.get_pos()) == cursorPos:
					actor.set_gray(true)
					actor.state += 1
					
					actor.attack(a)
#					var dam = preload("res://assets/prefabs/damage_popup.prefab.tscn").instance()
#					a.add_child(dam)
#					a.HP -= actor.attackPower
#					dam.get_node("value").set_text(str(actor.attackPower))
#					dam.set_pos(Vector2(0, -10))
					
					finish()
					
					get_tree().set_input_as_handled()
					return

func is_free(list, terrain, source):
	for A in list:
		var pos = terrain.world_to_map(A.get_pos())
		if pos == source:
			return false
	return true