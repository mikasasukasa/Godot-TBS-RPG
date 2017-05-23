extends Node

var manager #its group manager
var gambit = null
var delay
var owner #actor that owns me and that I will send orders to
var timer

func rnd(from, to):
	return floor(rand_range(from, to))

#here the AI will tell its actor what to do this turn!
func start():
	randomize()
	#just print some info
	Console.show(Console.AI, owner.name + "'s AI is going to start its play.")
	
	#load the thing
	gambit_load()
	
	#let the gambitManager do whatever it wants to the actor!
	gambit.retrieve_order()
	
	#wait for it to deal with its actor
	yield(gambit, "has_finished")
	
	#end its turn
	end()

func _process(dt):
	if timer > 0:
		timer -= 1
	else:
		end()

func end():
	set_process(false)
	manager.work()

func get_foes():
	
	var _foes = []
	
	for _actor in owner.scene.get_actors():
		if _actor.group != owner.group:
			_foes.append(_actor)
	
	return _foes

func gambit_load():
	if gambit == null:
		var fname = "res://assets/prefabs/gambits/" + owner._gambit + ".gb_manager.tscn"
		var file = File.new()
		var f
		
		if file.file_exists(fname):
			f = fname
		else:
			f = "res://assets/prefabs/gambits/move_randomly.gb_manager.tscn"
			
		var g = load(f).instance()
		add_child(g)
		g.AI = self
		gambit = g


func find_nearest_enemy():
	var distance = 999
	var nearest
	var n = {}
	
	#get my position in the map ("grid")
	var source = owner.get_map_position()
	
	#loop through the foes
	for foe in owner.get_foes():
		#get its position and find a path to it
		var dest = foe.get_map_position()
		var path = owner.scene.get_mstar().find_path_v(source, dest)
		
		#if nearest hasn't been set or the distance to THIS guy is lower than the current nearest
		if path.size() <= distance:
			#this is the new nearest
			distance = path.size()
			nearest = foe
			n["path"] = path
			n["actor"] = nearest
			n["distance"] = distance - 1
	
	#then we return the dictionary with the nearest and some useful data!
	return n
#
#
#
#
#
#
#func get_foes():
#	var _foes = []
#	for actor in owner.scene.get_actors():
#		if actor.group != owner.group:
#			_foes.append(actor)
#	
#	return _foes



func AI_move_randomly():
	var movable = owner.get_movable_panels()
	owner.find_path_to(movable[rnd(0, movable.size() - 1)])