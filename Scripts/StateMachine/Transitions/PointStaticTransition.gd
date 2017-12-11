class PointStaticTransition:
	
	var actions
	var targetState
	var condition
	
	var chaser
	var player
	var point
	
	func isTriggered():
		return self.condition.test()
	
	func getTargetState():
		targetState = state.StaticState.new()
		return targetState
	
	func getAction():
		return actions
	
	var cond = load("res://Scripts/Conditions/PointCondition.gd")
	var state = load("res://Scripts/States/StaticState.gd")

	func _init(chaser, player, point):
		chaser = chaser
		player = player
		point = point
		condition = cond.PointCondition.new(chaser,point)
		#targetState = state.StaticState.new()