extends Node

onready var scene = get_parent()

var hovered = null
var active = false
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
	
	set_process_input(true)

func start():
	get_node("userInterface/BBBB/turnPanel").set_hidden(false)
	get_cursor().set_hidden(false)
	get_cursor().activate(true)
	activate(true)

func set_turn(_turn):
	for actor in scene.get_actors():
		actor.set_gray(false)
		actor.state = 0
	
	turn = _turn
	get_node("userInterface/BBBB/turnPanel/turn").set_text(str(get_turn_name(turn)))
	
	if turn == 0:
		get_node("userInterface/BBBB/turnPanel/turn").set("custom_colors/font_color", Color("384ec4"))
	else:
		get_node("userInterface/BBBB/turnPanel/turn").set("custom_colors/font_color", Color(1.0, 0.25, 0.25, 1.0))
	
	print("Turn has changed to ", turn)
	#emit_signal("turn_has_changed", turn)
	
	get_cursor().activate(turn == 0)

func get_turn_name(_turn):
	if _turn == 0:
		return "Player"
	else:
		return "Enemy"

func _input(ev):
	#print("SD")
	if ev.is_action_pressed("ui_finish_turn"):
		if active && turn == 0:
			set_turn(1)
			activate(false)
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
		print("UUUU")
		
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
	else:
		print("AAAA")

func _on_cursor_has_clicked(sender):
	if active && hovered:
		var actions = get_node("userInterface/EEEE/actions")
		actions.set_hidden(false)
		actions.activate(true)
		actions.index = 0
		actions.update_info(hovered)
		
		get_cursor().activate(false)
		activate(false)
	
	
	
#	if active && hovered:
#		if hovered.state == 0:
#			activate(false)
#			sender.activate(false)
#			var _moveState = preload("res://assets/prefabs/battle_state_move.prefab.tscn").instance()
#			_moveState.actor = hovered
#			add_child(_moveState)
#		elif hovered.state == 1:
#			activate(false)
#			sender.activate(false)
#			var _actState = preload("res://assets/prefabs/battle_state_act.prefab.tscn").instance()
#			_actState.actor = hovered
#			add_child(_actState)

func activate(enable):
	print("BattleManager state changed to ", enable, ".")
	active = enable

func _on_letTheBattle_intro_has_ended():
	start()

func _on_actions_move_state_has_started(_sender, _actor):
	var _moveState = preload("res://assets/prefabs/battle_state_move.prefab.tscn").instance()
	_moveState.actor = _actor
	_moveState.from = _sender
	add_child(_moveState)
	
	get_cursor().activate(true)

func _on_actions_act_state_has_started(_sender, _actor):
	var _actState = preload("res://assets/prefabs/battle_state_act.prefab.tscn").instance()
	_actState.actor = _actor
	_actState.from = _sender
	add_child(_actState)
	
	get_cursor().activate(true)

func _on_actions_has_finished():
	activate(true)
	get_cursor().activate(true)