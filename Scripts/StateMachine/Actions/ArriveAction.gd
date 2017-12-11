class ArriveAction:
	
	var source
	var target

	const MAX_SPEED = 350
	const TIME_TO_TARGET = 0.25
	
	func arrive(source,target):
		var distance = Vector2(target - source)
		var new_velocity = Vector2(target - source).normalized() * MAX_SPEED
		var steering = KinematicSteeringOutput.new()
		steering.velocity = distance
		steering.velocity /= TIME_TO_TARGET
		if (steering.velocity.length() > MAX_SPEED):
			steering.velocity = new_velocity
		steering.orientation = distance.angle() 
		#set_rot(steering.orientation)
		return steering
	
	func _init(source, target):
		self.source = source
		self.target = target
		
	func run():
		var steering = KinematicSteeringOutput.new()
		steering = arrive(source,target)
		return steering
	
	class KinematicSteeringOutput:
		var velocity = Vector2()
		var orientation = 0.0