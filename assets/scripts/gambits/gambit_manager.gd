extends Node

var AI
signal has_finished

func start():
	pass

#this will loop through the gambitTree and retrieve the orders for the AI to send to its actor!
func retrieve_order():
	var order = null
	for g in get_children():
		if g.is_able():
			g.send_order()
			order = g
			break
	
	#if there's any order (there should always be!)
	if order != null:
		yield(order, "has_finished")
	
	#wait for it to finish and then let the AI know it finished ordering the actor
	emit_signal("has_finished")

func get_AI():
	return AI

func get_AI_actor():
	return AI.owner