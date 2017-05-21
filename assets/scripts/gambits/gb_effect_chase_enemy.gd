extends Node

export(String, "causer", "nearest", "furthest") var target

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func effect():
	get_parent().actor.