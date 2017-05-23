extends Node

var friendsWith = []
var toPlay = []
var actors = []
var manager
var index
var isAI

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _input(ev):
	if ev.is_action_pressed("end_turn"):
		set_process_input(false)
		end_turn()
		get_tree().set_input_as_handled()

func start():
	Console.show(Console.AI, "(AI) groupManager"  + str(index) + " has started the turn ----------------------------- (isAI: " + str(isAI) + ")")
	
	#toPlay = []
	
	
	if isAI:
		#check if any of the actors doesn't have an AI, if not, add
		var _AI = preload("res://assets/prefabs/battle/actor_AI.prefab.tscn")
		
		#get the units of the team
		for i in manager.scene.get_actors():
			if i.group == index:
				toPlay.append(i)
		
		#loop through the actors and if they don't have an AI attached to them, do so
		for i in toPlay:
			if i.get_AI() == null:
				var AI = _AI.instance()
				AI.owner = i
				AI.manager = self
				
				i.add_child(AI)
				
				Console.show(Console.AI, "AI added to " + i.name)
		
		#WHERE SHITE HAPPENS
		work()
	else:
		#let the player play
		set_process_input(true)

func work():
	Console.show(Console.AI, "(AI) groupManager"  + str(index) + " has started working...")
	if toPlay.size() > 0:
		#tell the first actor's AI to work
		toPlay.front().get_AI().start()
		toPlay.pop_front()
	else:
		#end turn
		end_turn()

func _on_delay_timeout():
	pass # replace with function body

func end_turn():
	Console.show(Console.AI, "(AI) groupManager " + str(index) + " finished the turn -----------------------------")
	manager.end_turn()