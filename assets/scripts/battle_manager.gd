extends Node

onready var scene = get_parent()

var hovered = null
var active = true
var turn = 0
var mstar

var enemyAI

signal turn_has_changed
signal has_found_an_actor

func _ready():
	
	scene.manager = self
	
	enemyAI = preload("res://assets/scripts/battle_ai.gd").new()
	enemyAI.manager = self
	set_turn(0)
	add_child(enemyAI)
	
	for a in scene.get_actors():
		fix_position(a)
	
	fix_position(get_cursor())
	
#	var t = scene.get_terrain_collider().get_used_rect()
#	#var m = max(t.x, t.y)
#	mstar = preload("res://assets/scripts/mstar.gd").new(50, 50)
#	mstar.block_based_on_tilemap(scene.get_terrain_collider())
	
	get_node("userInterface/BBBB/turn").set_text(str(turn))
	set_process_input(true)

func set_turn(_turn):
	for actor in scene.get_actors():
		actor.set_gray(false)
		actor.state = 0
	
	turn = _turn
	get_node("userInterface/BBBB/turn").set_text(str("Turn: ", turn))
	print("Turn has changed to ", turn)
	#emit_signal("turn_has_changed", turn)
	
	get_cursor().activate(turn == 0)
	
	

func _input(ev):
	#print("SD")
	if ev.is_action_pressed("ui_finish_turn"):
		#print("IAUSHDIUASHDIUSAHDI")
		if turn == 0:
			set_turn(1)
			activate(false)
			get_node("userInterface/BBBB/turn").set_text(str("Turn: ", turn))
			print("Turn has changed to ", turn)
			
			enemyAI.start()
			get_tree().set_input_as_handled()

func get_scene():
	return scene

func get_cursor():
	return get_node("cursor")

func fix_position(node):
	var terrain = scene.get_terrain()
	
	var m = terrain.world_to_map(node.get_pos())
	var w = terrain.map_to_world(m)
	
	node.set_pos(w + Vector2(0, terrain.get_cell_size().y * 0.5))

func map_to_world_fixed(position):
	var terrain = scene.get_terrain()
	return terrain.map_to_world(position) + Vector2(0, terrain.get_cell_size().y * 0.5)

func _on_cursor_has_moved(sender):
	if active:
		var cursorPosM = scene.get_terrain().world_to_map(sender.get_pos())
		
		for actor in scene.get_actors():
			var actorPosM = scene.get_terrain().world_to_map(actor.get_pos())
			
			if cursorPosM == actorPosM:
				print("The cursor has found an actor!")
				hovered = actor
				emit_signal("has_found_an_actor", hovered)
				
				return
		
		hovered = null
		emit_signal("has_found_an_actor", hovered)

func _on_cursor_has_clicked(sender):
	if active && hovered:
		if hovered.state == 0:
			activate(false)
			sender.activate(false)
			var _moveState = preload("res://assets/prefabs/battle_state_move.prefab.tscn").instance()
			_moveState.actor = hovered
			add_child(_moveState)
		elif hovered.state == 1:
			activate(false)
			sender.activate(false)
			var _actState = preload("res://assets/prefabs/battle_state_act.prefab.tscn").instance()
			_actState.actor = hovered
			add_child(_actState)

func activate(enable):
	print("BattleManager state changed to ", enable, ".")
	active = enable