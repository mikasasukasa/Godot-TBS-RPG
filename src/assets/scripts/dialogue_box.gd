extends CanvasLayer

var speaker = []
var speech = []

var manager

#func _ready():
#	start(null, "CASTLE_INTRO_01")
#	pass

func start(_manager, _dialogue):
	
	set_process_input(true)
	
	manager = _manager
	
	var dialogue = load("res://assets/prefabs/dialogues/" + _dialogue + ".dialogue.tscn").instance()
	
	for i in dialogue.get_children():
		speaker.append(i.speaker)
		speech.append(i.speech)
	
	get_node("EBBB/box/speaker").set_text(speaker.front())
	get_node("EBBB/box/speech").set_text(speech.front())
	
	
	#for i in range(speaker.size()):
	#	print(speaker[i], ": ", speech[i])

func _input(ev):
	if ev.is_action_pressed("ui_accept"):
		step()

func step():
	speaker.pop_front()
	speech.pop_front()
	
	if speaker.size() == 0:
		end()
	else:
		get_node("EBBB/box/speaker").set_text(speaker.front())
		
		var _spch = get_node("EBBB/box/speech")
		
		
		_spch.set_text(speech.front())
		

func end():
	queue_free()
	
	if manager:
		manager.end()