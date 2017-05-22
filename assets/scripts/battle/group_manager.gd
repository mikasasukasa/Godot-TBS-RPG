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
		manager.end_turn()

func start():
	if isAI:
		#check if any of the actors doesn't have an AI, if not, add
		var _AI = preload("res://assets/prefabs/battle/actor_AI.prefab.tscn")
		
		#loop through the actors and if they don't have an AI attached to them, do so
		for _actor in actors:
			if _actor.get_AI() == null:
				_actor = add_child(_AI.instance())
		
		#update the list of actors 
		toPlay = [] + actors
		work()
	else:
		#let the player play
		set_process_input(true)

func work():
	Console.show(Console.AI, "(AI) groupManager has started working...")
	if toPlay.size() > 0:
		#tell the first actor's AI to work
		toPlay.front().AI.start()
		toPlay.pop_front()
	else:
		#end turn
		manager.end_turn()

func _on_delay_timeout():
	pass # replace with function body
