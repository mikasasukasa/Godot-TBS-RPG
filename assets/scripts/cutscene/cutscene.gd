extends Node

onready var scene = get_parent()
var content = []
var contentNow = []

func _ready():
	set_process_input(true)
	start()

func start():
	for c in get_children():
		content.append(c)
	
	for c in get_children():
		contentNow.append(c)
		
		if c.should_wait_end():
			break
	
	Console.show(Console.CUT, get_name() + " has started!")
	work()

func work():
	if content.size() > 0:
		var f = content.front()
		Console.show(Console.CUT, f.get_name() + " has started!")
		f.start(self)
	else:
		Console.show(Console.CUT, get_name() + " has ended!")

func _input(ev):
	if ev.is_action_pressed("ui_skip_cutscene"):
		for c in get_children():
			c.skip()