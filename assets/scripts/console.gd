extends Node

#These bools define if a kind of message will be shown via console
var BATTLE = true
var ACTOR = true
var CUT = false
var AI = true

func show(type, message):
	if type:
		print(message)