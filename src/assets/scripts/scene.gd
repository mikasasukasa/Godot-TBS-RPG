extends Node

var mstar
var start
var end

var manager

func _ready():
	set_process(true)
	set_process_input(true)
	
	#var terrainSize = get_terrain().get_used_rect().size
	#var m = max(terrainSize.width, terrainSize.height)
	mstar = preload("res://assets/scripts/mstar.gd").new(50, 50)
	mstar.block_based_on_tilemap(get_terrain_collider())

func get_terrain():
	return get_node("terrain")

func get_manager():
	return manager

func get_mstar():
	return mstar

func get_terrain_collider():
	return get_node("terrain/collider")

func get_actors():
	var actors = []
	
	for a in get_node("objects").get_children():
		if a.is_in_group("actors"):
			actors.append(a)
	
	return actors

func get_actors_from_group(g):
	var actors = []
	
	for a in get_node("objects").get_children():
		if a.is_in_group("actors"):
			if a.group == g:
				actors.append(a)
	
	return actors

func map_to_world_fixed(position):
	var terrain = get_terrain()
	return terrain.map_to_world(position) + Vector2(0, terrain.get_cell_size().y * 0.5)

func _input(event):
	if event.is_action_pressed("ui_down"):
		#get_node("CASTLE_INTRO").start()
		pass