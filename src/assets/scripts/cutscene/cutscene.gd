extends Node

onready var scene = get_parent()
var content = []

func _ready():
	#start()
	pass

func start():
	for c in get_children():
		content.append(c)
	work()

func work():
	if content.size() > 0:
		content.front().start(self)
	else:
		print(get_name(), " has ended!")