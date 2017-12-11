class PointCondition:
	var source
	var point
	
	func _init(source, point):
		source = source
		point = point
	
	func test():
		return source == point