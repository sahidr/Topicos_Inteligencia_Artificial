class PlayerPointTransition:

	var actions
	var targetState
	var condition
	
	var chaser
	var player
	var point
		
	func isTriggered():
		return self.condition.test()
	
	func getTargetState():
		targetState = state.FollowPointState.new()
		return targetState
	
	func getAction():
		return actions
	
	var state = load("res://Scripts/States/StateMachine/FollowPointState.gd")
	var cond = load("res://Scripts/Conditions/StateMachine/FarnessCondition.gd")
	
	var distance = 300
	
	func _init(chaser, player, point):
		chaser = chaser
		player = player
		point = point
		condition = cond.FarnessCondition.new(chaser,player,distance)
		#targetState = state.FollowPointState.new()