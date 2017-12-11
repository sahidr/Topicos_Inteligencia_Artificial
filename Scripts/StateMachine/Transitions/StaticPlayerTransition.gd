class StaticPlayerTransition:
	
	#onready var player_p = get_node("Player")
	#onready var chaser_p = get_parent().get_node("chaser")
	
	var actions
	var targetState
	var condition
	
	var chaser# = global.chaser
	var player# = global.player
	#var point# = Vector2(1400,1400)
	
	func isTriggered():
		return condition.test()
	
	func getTargetState():
		targetState = state.FollowPlayerState.new(global.chaser,global.player,global.point)
		return targetState
	
	func getAction():
		return actions

	var state = load("res://Scripts/States/FollowPlayerState.gd")
	var cond = load("res://Scripts/Conditions/ClosenessCondition.gd")
	
	var distance = 300
	
	func _init():
	#func _init(chaser, player, point):
		#chaser = chaser_p.get_pos()
		#player = player_p.get_pos()
	#func _init(): 
		#point = point
		#print(player)
		condition = cond.ClosenessCondition.new(chaser,player,distance)
		#targetState = state.FollowPlayerState.new()