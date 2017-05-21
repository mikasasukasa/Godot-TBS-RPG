extends Sprite

export var name = "Unnamed"
export var group = 0
export var move = 5
export var attackRange = 1

export var attackPower = 24

export var maxHP = 100
export var HP = 100

export(Texture) var hitAnimation
var walkAnimation

var performingAnimation = false

export var _gambit = ""

var path = []

var state = 0

var AI

#var nearest = {}
var myManagerAI = null
var waitAI = 30
var isAI = false

var animIndex = 0.0
var animAngle = 0

var gambit

var aiActionEndTimer = -1

var isWaitingForNextStepAI = false
var nextStepTimerAI = 0

onready var scene = get_parent().get_parent()

func _ready():
	#path.append(Vector2(50, 50))
	#init_gambit()
	
	AI = preload("res://assets/scripts/battle/actor_AI.gd").new(self)
	
	#walkAnimation = get_texture()
	set_process(true)
	pass

func init_gambit():
	var filename = "res://assets/prefabs/gambits/" + _gambit + ".gambits.tscn"
	var file = File.new()
	
	if file.file_exists(filename):
		var g = load(filename)
		gambit = g.instance()
		Console.show(Console.AI, "Gambit initialized properly!")
	else:
		Console.show(Console.AI, "Gambit not found!")

func should_move():
	return path.size() > 0

func _process(delta):
	
	if performingAnimation:
		if animIndex < 3.0 - 0.2:
			animIndex += 0.2
			set_frame(animAngle * 4 + floor(animIndex))
		else:
			animIndex = 0.0
			performingAnimation = false
			set_texture(walkAnimation)
	
	if isAI && isWaitingForNextStepAI:
		if nextStepTimerAI <= 0:
			isWaitingForNextStepAI = false
			ai_make_decision(myManagerAI)
		else:
			nextStepTimerAI -= 1
	
	if should_move():
		var motion = path[0] - get_pos()
		
		if motion.length_squared() < 0.5 * 0.5:
			set_pos(path[0])
				
			if path.size() > 1:
				look_at(path[1])
			else:
				animIndex = 0
				set_frame(animAngle * 4 + floor(animIndex))
				#translate(motion.normalized() * 0.5)
			
			path.pop_front()
			
			if isAI && path.size() == 0:
				ai_wait_and_step(15)
		else:
			if animIndex < 3.0 - 0.2:
				animIndex += 0.2
			else:
				animIndex = 0.0
			set_frame(animAngle * 4 + floor(animIndex))
			
			#Console.show(Console.ACTOR, ["FRAME: ", animAngle * 4 + floor(animIndex)])
				
			translate(motion.normalized() * 0.5)

func ai_wait_and_step(time):
	nextStepTimerAI = time
	isWaitingForNextStepAI = true

func ai_make_decision(_manager):
	isAI = true
	myManagerAI = _manager
	
#	if state == 0:
#		#Console.show(Console.AI, "AI SHOULD MOVE")
#		ai_move()
#		state += 1
#	elif state == 1:
#		#Console.show(Console.AI, "AI SHOULD ACT")
#		var a = ai_act()
#		
#		if a:
#			state += 1
#		else:
#			#print("AI SHOULD SHOULD ABORT")
#			set_gray(true)
#			state += 1
#			#isAI = false
#			#myManagerAI.make_decision()
#	else:
#		#print("AI SHOULD SHOULD END")
#		set_gray(true)
#		isAI = false
#		myManagerAI.make_decision()
	

func set_gray(enable):
	if enable:
		set_material(load("res://assets/shaders/black_white.material.tres"))
	else:
		set_material(null)

#THIS WILL RETURN THE PANELS (VECTOR2'S) THIS ACTOR CAN MOVE TO!
func get_targettable_panels():
	#its position in the map
	var source = get_map_position()#scene.get_terrain().world_to_map(get_pos())
	#var actors = scene.get_actors()
	var targettable = []
	#var actorsPos = []
	
#	#first of all, let's forbid enemy cells (allies' stay free as they can move through them)
#	for actor in actors:
#		#if self, ignore (since an unit can move to its own panel)
#		if actor == self:
#			continue
#		
#		#let's keep track of actors positions to use later!
#		var ap = actor.get_map_position()#scene.get_terrain().world_to_map(actor.get_pos())
#		actorsPos.append(ap)
#		
#		#forbid actor's position if it's from another team
#		if actor.get_group() != group:
#			scene.get_mstar().forbidv(ap)
	
	for x in range(max(1, source.x - attackRange), source.x + attackRange + 1):
		for y in range(max(1, source.y - attackRange), source.y + attackRange + 1):
			#getting the position
			var pos = Vector2(x, y)
			
			if pos == source:
				continue
			
			#if the panel is occupied by an actor
#			var isOccupied = false
#			for p in actorsPos:
#				if pos == p:
#					isOccupied = true
#					break
			
#			if isOccupied:
#				continue
			
			#if it's not close enough
			var difference = pos - source
			if abs(difference.x) + abs(difference.y) > attackRange:
				continue
			
			#if nothing works, I have to use A* to find out
			#var path = scene.get_mstar().find_path_v(source, pos)
			#if path.size() < 1 || path.size() > attackRange + :
			#	continue
			
			#seems like it's available ;_;
			targettable.append(pos)
	
	#free the stuff we forbid before
#	for ap in actorsPos:
#		scene.get_mstar().freecv(ap)
	
	return targettable


#THIS WILL RETURN THE PANELS (VECTOR2'S) THIS ACTOR CAN MOVE TO!
func get_movable_panels():
	#its position in the map
	var source = get_map_position()#scene.get_terrain().world_to_map(get_pos())
	var actors = scene.get_actors()
	var actorsPos = []
	var movable = []
	
	#first of all, let's forbid enemy cells (allies' stay free as they can move through them)
	for actor in actors:
		#if self, ignore (since an unit can move to its own panel)
		if actor == self:
			continue
		
		#let's keep track of actors positions to use later!
		var ap = actor.get_map_position()#scene.get_terrain().world_to_map(actor.get_pos())
		actorsPos.append(ap)
		
		#forbid actor's position if it's from another team
		if actor.get_group() != group:
			scene.get_mstar().forbidv(ap)
	
	for x in range(max(1, source.x - move), source.x + move + 1):
		for y in range(max(1, source.y - move), source.y + move + 1):
			#getting the position
			var pos = Vector2(x, y)
			
			if pos == source:
				continue
			
			#if the panel is occupied by an actor
			var isOccupied = false
			for p in actorsPos:
				if pos == p:
					isOccupied = true
					break
			
			if isOccupied:
				continue
			
			#if it's not close enough
			var difference = pos - source
			if abs(difference.x) + abs(difference.y) > move:
				continue
			
			#if nothing works, I have to use A* to find out
			var path = scene.get_mstar().find_path_v(source, pos)
			if path.size() < 1 || path.size() > move:
				continue
			
			#seems like it's available ;_;
			movable.append(pos)
	
	#free the stuff we forbid before
	for ap in actorsPos:
		scene.get_mstar().freecv(ap)
	
	return movable

func get_move():
	return move

func get_group():
	return group

func get_nearest_foe():
	
	var nearest = null
	var nearestDistance = 0
	
	var source = get_map_position()
	
	for foe in get_foes():
		var pos = foe.get_map_position()
		var path = scene.get_mstar().find_path_v(source, pos)
		
		if path.size() < nearestDistance:
			nearestDistance = path.size()
			nearest = foe
	
	return nearest

func get_nearest_foe_and_info():
	var nearest = null
	var distance = 999
	var n = {}
	
	#get my position in the map ("grid")
	var source = get_map_position()
	
	#loop through the foes
	for foe in get_foes():
		#get its position and find a path to it
		var pos = foe.get_map_position()
		var path = scene.get_mstar().find_path_v(source, pos)
		
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

func get_furthest_foe_and_info():
	var furthest = null
	var distance = 0
	var n = {}
	
	#get my position in the map ("grid")
	var source = get_map_position()
	
	#loop through the foes
	for foe in get_foes():
		#get its position and find a path to it
		var pos = foe.get_map_position()
		var path = scene.get_mstar().find_path_v(source, pos)
		
		#if nearest hasn't been set or the distance to THIS guy is lower than the current nearest
		if path.size() > distance:
			#this is the new nearest
			distance = path.size()
			furthest = foe
			n["path"] = path
			n["actor"] = nearest
			n["distance"] = distance - 1
	
	#then we return the dictionary with the nearest and some useful data!
	return n

func get_actor_info(_actor):
	var pos = _actor.get_map_position()
	var path = scene.get_mstar().find_path_v(get_map_position(), _actor.get_map_position())
	
	#if nearest hasn't been set or the distance to THIS guy is lower than the current nearest
	if path.size() > distance:
		#this is the new nearest
		distance = path.size()
		furthest = foe
		n["path"] = path
		n["actor"] = nearest
		n["distance"] = distance - 1

func get_map_position():
	return scene.get_terrain().world_to_map(get_pos())

func get_foes():
	
	var _f = []
	
	for actor in scene.get_actors():
		if actor.group != group:
			_f.append(actor)
	
	return _f

func AI_move_towards_actor(_actor):
	#get the nearest enemy
	#var nearest = get_nearest_foe_and_info()
	#print("AI:", name, " just found ", nearest["actor"].name, " to be the nearest. Distance: ", nearest["distance"])
	
	#invert the path to it because we will be checking from backwards
	nearest["path"].invert()
	var movable = get_movable_panels()
	
	#loop through the path to the nearest foe
	for i in nearest["path"]:
		#if i can move to that panel, do so
		if can_move_to(movable, i):
			find_path_to(i)

func ai_act():
	var nearest = get_nearest_foe_and_info();
	
	isWaitingForNextStepAI = true
	
	if can_attack(get_targettable_panels(), nearest["actor"]):
		attack(nearest["actor"])
		nextStepTimerAI = 30
		return true
	else:
		nextStepTimerAI = 5
		return false

func attack(target):
	var dam = preload("res://assets/prefabs/damage_popup.prefab.tscn").instance()
	dam.set_pos(target.get_pos() + Vector2(0, -10))
	get_parent().add_child(dam)
	target.HP -= attackPower
	
	#target.perform_animation("hit")
	
	#if target.hitAnimation:
	#	target.set_texture(target.hitAnimation)
	
	dam.get_node("value").set_text(str(attackPower))
	
	if target.HP <= 0:
		target.queue_free()

#TO DETERMINE IF AN ACTOR CAN MOVE TO A PANEL
func can_move_to(movablePanels, pos):
	for m in movablePanels:
		if m == pos:
			return true
	
	return false

func can_attack(targettablePanels, target):
	for m in targettablePanels:
		if m == target.get_map_position():
			return true
	
	return false
	
	
	#for actor in scene.get_actors():
	
	#first we generate a path from it to the panel
	#var path = scene.get_mstar().find_path_v(get_map_position(), pos)
	
	#if the path exists (> 0) and its size and equals or is lower than move (<=), vòila
	#return path.size() > 0 && path.size() <= move

func perform_animation(anim):
	
	var _anim
	
	if anim == "hit" && hitAnimation:
		_anim = hitAnimation
	
	if _anim:
		set_texture(_anim)
		performingAnimation = true

func block_enemy_cells(enable):
	if enable:
		for _actor in scene.get_actors():
			#forbid actor's position if it's from another team
			if _actor.get_group() != group:
				var p = _actor.get_map_position()
				scene.get_mstar().forbidv(p)
				
				#var m = scene.get_mstar()
				#print(m.astar.get_point_pos(m.flatten(p.x, p.y)), " has been FORBIDDEN!")
	else:
		for _actor in scene.get_actors():
			#forbid actor's position if it's from another team
			if _actor.get_group() != group:
				scene.get_mstar().freecv(_actor.get_map_position())

func find_path_to(position):
	block_enemy_cells(true)
	var _path = scene.get_mstar().find_path_v(scene.get_terrain().world_to_map(get_pos()), position)
	block_enemy_cells(false)

	for p in _path:
		path.append(scene.map_to_world_fixed(p))
	
	if path.size() > 1:
		look_at(path[1])

func look_at(position):
	var vector = position - get_pos()
	var angle = get_correct_angle(vector.angle())
	
	animAngle = get_angle_side(angle)
	
	#set_frame(get_angle_side(angle))
	
	#print("looking at angle: ", angle, " --> ", get_angle_string(angle))

func get_angle_string(degrees):
	if abs(115 - degrees) < 20:
		return "DOWN"
	if abs(245 - degrees) < 20:
		return "RIGHT"
	if abs(295 - degrees) < 20:
		return "UP"
	if abs(65 - degrees) < 20:
		return "LEFT"
	
	return "---"

func get_angle_side(degrees):
	if abs(115 - degrees) < 20:
		return 1
	if abs(245 - degrees) < 20:
		return 0
	if abs(295 - degrees) < 20:
		return 2
	if abs(65 - degrees) < 20:
		return 3
	
	return 0

func get_correct_angle(angle):
	return rad2deg(angle) + 180.0

#func fix_position(position):
#	var terrain = get_terrain()
#	return terrain.map_to_world(position) + Vector2(0, terrain.get_cell_size().y * 0.5)