class Transition:

	var actions
	var targetState
	var condition
	
	func isTriggered():
		return self.condition.test()
	
	func getTargetState():
		return targetState
	
	func getAction():
		return actions