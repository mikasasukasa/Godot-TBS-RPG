extends Node

#actor that owns me and that I will send orders to!
var manager
var delay
var owner

var timer = -1

func start():
	Console.show(Console.AI, owner.name + "'s AI is going to start its play.")
	
	#manager.work()
	
#	delay = Timer.new()
#	delay.set_wait_time(1.0)
#	delay.start()
#	
#	manager.add_child(delay)
#	delay.connect("timeout", self, "on_delay_timeout")
	
	
	timer = 45
	set_process(true)
	#end()

func _process(dt):
	if timer > 0:
		timer -= 1
	else:
		end()

func end():
	print("WOOOORK BITCH")
	manager.work()

func get_foes():
	
	var _foes = []
	
	for _actor in owner.scene.get_actors():
		if _actor.group != owner.group:
			_foes.append(_actor)
	
	return _foes




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