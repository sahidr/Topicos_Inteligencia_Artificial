class StateMachine:
	
	#var states
	var initialState
	var currentState
	
	func _init(initial):
		initialState = initial
		currentState = initial

	func update():
		#print("eatoy actualizando")
		var targetState
		var actions = []
		var triggeredTransition = null
		
		var transitions = currentState.getTransitions()
		for transition in transitions:
			if transition.isTriggered():
				triggeredTransition = transition
				break
		if triggeredTransition != null:
			# Find the target state

			targetState = triggeredTransition.getTargetState()
			var exit = currentState.getExitAction()
			var action = triggeredTransition.getAction()
			var entry = targetState.getEntryAction()

			actions.append(exit)
			actions.append(action)
			actions.append(entry)

			currentState = targetState
			return actions
		else: 
			return currentState.getAction()