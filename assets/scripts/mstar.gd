#DON'T SET SHIT, THEY WILL BE SET IN INITIALIZE()
var width    = 0
var height   = 0
var astar
var map = []

const FREE = 0
const FORBIDDEN = 1

func _init(_width, _height):
	#set properties
	width = _width
	height = _height
	
	map.resize(width * height)
	
	#create the AStar
	astar = AStar.new()
	
	#add the points
	for x in range(width):
		for y in range(height):
			astar.add_point(flatten(x, y), Vector3(x, y, 0))
	
	#connect the points
	for x in range(width):
		for y in range(height):
			#get current point and its position
			var current = flatten(x, y)
			var cpos = astar.get_point_pos(current)
			
			map[flatten(x, y)] = FREE
			
			#get neighbours
			var u = cpos + Vector3(0, -1, 0)
			var d = cpos + Vector3(0,  1, 0)
			var r = cpos + Vector3( 1, 0, 0)
			var l = cpos + Vector3(-1, 0, 0)
			
			#connect points
			if point_within(u.x, u.y) && !astar.are_points_connected(current, flatten(u.x, u.y)):
				astar.connect_points(current, flatten(u.x, u.y))
			
			if point_within(d.x, d.y) && !astar.are_points_connected(current, flatten(d.x, d.y)):
				astar.connect_points(current, flatten(d.x, d.y))
			
			if point_within(r.x, r.y) && !astar.are_points_connected(current, flatten(r.x, r.y)):
				astar.connect_points(current, flatten(r.x, r.y))
			
			if point_within(l.x, l.y) && !astar.are_points_connected(current, flatten(l.x, l.y)):
				astar.connect_points(current, flatten(l.x, l.y))

#=============== HELPERS

#this will block the cells based on a tilemap
func block_based_on_tilemap(tilemap):
	for x in range(width):
		for y in range(height):
			if tilemap.get_cell(x, y) >= 0:
				#print(Vector2(x, y), " is forbidden!")
				#set_point_weight_scale 
				forbid(x, y)

func get_size():
	return Vector2(width, height)
	
func forbidv(_pos):
	forbid(_pos.x, _pos.y)
	
func forbid(_x, _y):
	var current = flatten(_x, _y)#this will do x * width + y to return the id
	disconnect_with_neighbour_at(current, Vector2( 1,  0))
	disconnect_with_neighbour_at(current, Vector2(-1,  0))
	disconnect_with_neighbour_at(current, Vector2( 0,  1))
	disconnect_with_neighbour_at(current, Vector2( 0, -1))
	map[current] = FORBIDDEN

func freec(_x, _y):
	var current = flatten(_x, _y)#this will do x * width + y to return the id
	connect_with_neighbour_at(current, Vector2( 1,  0))
	connect_with_neighbour_at(current, Vector2(-1,  0))
	connect_with_neighbour_at(current, Vector2( 0,  1))
	connect_with_neighbour_at(current, Vector2( 0, -1))
	map[current] = FREE

func freecv(_pos):
	freec(_pos.x, _pos.y)

func flatten(_x, _y):
	return _x * width + _y

func point_within(_x, _y):
	return (_x >= 0 && _y >= 0 && _x < width  && _y < height)


func connect_with_neighbour_at(point_id, offset):
	#get current point and its position
	var cpos = astar.get_point_pos(point_id)
	
	var p = cpos + Vector3(offset.x, offset.y, 0)
	
	#connect points
	if point_within(p.x, p.y) && map[flatten(p.x, p.y)] == FREE && !astar.are_points_connected( point_id, flatten(p.x, p.y)):
		astar.connect_points(point_id, flatten(p.x, p.y))

func disconnect_with_neighbour_at(point_id, offset):
	#get current point and its position
	var cpos = astar.get_point_pos(point_id)
	var p = cpos + Vector3(offset.x, offset.y, 0)
	
	#connect points
	if point_within(p.x, p.y) && astar.are_points_connected( point_id, flatten(p.x, p.y) ):
		astar.disconnect_points(point_id, flatten(p.x, p.y))

func show_path_info(path):
	print(path.size())
	
	for i in path:
		print(i)

func find_path(x1, y1, x2, y2):
	return astar.get_point_path(flatten(floor(x1), floor(y1)), flatten(floor(x2), floor(y2)))

func find_path_v(_src, _dest):
	
	var src = astar.get_point_path(flatten(floor(_src.x), floor(_src.y)), flatten(floor(_dest.x), floor(_dest.y)))
	var dest = []
	
	for point in src:
		dest.append(Vector2(point.x, point.y))
	
	return dest

func find_path_mult_offset(x1, y1, x2, y2, mult, offset):
	var source = astar.get_point_path(flatten(x1, y1), flatten(x2, y2))
	var dest = []
	
	for point in source:
		dest.append(Vector2(point.x, point.y) * mult + offset)
	
	return dest

func find_path_mult_offset_vec(_source, _dest, mult, offset):
	var source = astar.get_point_path(flatten(_source.x, _source.y), flatten(_dest.x, _dest.y))
	var dest = []
	
	for point in source:
		dest.append(Vector2(point.x, point.y) * mult + offset)
	
	return dest


func get_reachable_panels(_source, _range, _min, _max):
	
	var reachable = []
	
	for x in range(max(_min.x, _source.x - _range), min(_source.x + _range + 1, _max.x)):
			for y in range(max(_min.y, _source.y - _range), min(_source.y + _range + 1, _max.y)):
				
				var path = find_path(_source.x, _source.y, x, y)
				
				if path.size() > 1 && path.size() <= _range + 1:
					reachable.append(Vector2(x, y))
	
	return reachable

func get_reachable_panels_mult_offset(_source, _range, _min, _max, mult, offset):
	
	var reachable = []
	
	for x in range(max(_min.x, _source.x - _range), min(_source.x + _range + 1, _max.x)):
			for y in range(max(_min.y, _source.y - _range), min(_source.y + _range + 1, _max.y)):
				
				var path = find_path(_source.x, _source.y, x, y)
				
				if path.size() > 1 && path.size() <= _range + 1:
					reachable.append(Vector2(x, y) * mult + offset)
	
	return reachable