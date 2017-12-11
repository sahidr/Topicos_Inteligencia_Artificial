class State:
	var id 
	var transitions = []
	var entryAction = []
	var action = []
	var exitAction = []

	func getAction():
		return action
		
	func getEntryAction():
		return entryAction
		
	func getExitAction():
		return exitAction
		
	func getTransitions():
		return transitions
