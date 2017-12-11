class FollowPointState:
	var chaser
	var player
	var point

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
	
	var arriveAction = load("res://Scripts/StateMachine/Actions/ArriveAction.gd")
	var transition = load("res://Scripts/StateMachine/Transitions/PointStaticTransition.gd")

	func _init(chaser,player,point):
		chaser = chaser
		player = player
		point = point		
		var action = arriveAction.ArriveAction.new(chaser,point)
		actions.append(action)
		var pointStatic = transition.PointStaticTransition.new()
		transitions.append(pointStatic)