extends TextureFrame

export var options = 0
var active = false
var index = 0
var actor

signal move_state_has_started
signal act_state_has_started
signal has_finished

func _ready():
	pass

func update_info(_actor):
	Console.show(Console.BATTLE, "Actions menu updated!")
	actor = _actor
	get_node("arrow").set_pos(get_child(index).get_pos() + Vector2(-6, 2))

func activate(enable):
	active = enable
	set_process_input(active)
	

func _input(ev):
	if ev.is_action_pressed("ui_up"):
		index = max(0, index - 1)
		get_node("arrow").set_pos(get_child(index).get_pos() + Vector2(-6, 2))
	
	elif ev.is_action_pressed("ui_down"):
		index = min(options - 1, index + 1)
		get_node("arrow").set_pos(get_child(index).get_pos() + Vector2(-6, 2))
	
	elif ev.is_action_pressed("ui_accept"):
		if index == 0:
			activate(false)
			set_hidden(true)
			emit_signal("move_state_has_started", self, actor)
		
		elif index == 1:
			activate(false)
			set_hidden(true)
			emit_signal("act_state_has_started", self, actor)
		
		elif index == 2:
			activate(false)
			set_hidden(true)
			emit_signal("has_finished")
			get_tree().set_input_as_handled()
	
	elif ev.is_action_pressed("ui_cancel"):
		activate(false)
		set_hidden(true)
		emit_signal("has_finished")
		get_tree().set_input_as_handled()