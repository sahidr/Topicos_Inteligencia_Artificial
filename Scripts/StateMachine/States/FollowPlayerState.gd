class FollowPlayerState:
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
		
	var arriveAction = load("res://Scripts/Actions/ArriveAction.gd")
	var transition = load("res://Scripts/Transitions/PlayerPointTransition.gd")
	
	func _init(chaser,player,point):
		chaser = chaser
		player = player
		point = point
		var arrive = arriveAction.ArriveAction.new(chaser,player)
		actions.append(arrive)
		var playerPoint = transition.PlayerPointTransition.new(global.chaser,global.player,global.point)
		transitions.append(playerPoint)