class StaticState:
	
	onready var player = get_parent().get_node("Player")
	onready var chaser = get_parent().get_node("chaser")
	
	
	var staticAction = load("res://Scripts/StateMachine/Actions/StaticAction.gd")
	var transition = load("res://Scripts/StateMachine/Transitions/StaticPlayerTransition.gd")

	#var chaser
	#var player
	#var point
	
	var id
	var transitions = []
	var entryActions = []
	var actions = []
	var exitActions = []

	func getAction():
		return actions
		
	func getEntryAction():
		return entryActions
		
	func getExitAction():
		return exitActions
		
	func getTransitions():
		return transitions

	func _init():
	#func _init(chaser,player,point):
		id = "StaticState"
		#chaser = global.chaser
		#player = global.player
		#point = global.point
		var staticA = staticAction.StaticAction.new()
		actions.append(staticA)
		var staticPlayer = transition.StaticPlayerTransition.new()#chaser,player,point)
		transitions.append(staticPlayer)