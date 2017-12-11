class FarnessCondition:
	var source
	var target
	var distance
	
	func _init(source, target, distance):
		source = source
		target = target
		distance = distance
	
	func test():
		#var dist = sqrt(pow(target.x - source.x,2) + pow(target.y - source.y,2))
		var dist = 150
		return dist >= 300