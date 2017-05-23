extends Node

onready var manager = get_parent()

signal has_finished

#this is the condition for the effect to happen, in the case of moving,
#nothing impedes the actor to do so
func is_able():
	return true

#handle the actor and then let the AI knows it's done with sending orders
func send_order():
	#move randomly
	manager.get_AI().AI_move_randomly()
	yield(manager.get_AI_actor(), "has_finished_moving")
	
	#DONE!
	emit_signal("has_finished")