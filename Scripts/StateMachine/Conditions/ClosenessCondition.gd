extends Node2D

class ClosenessCondition:
	
	var source
	var target
	var distance = 300
	
	func _init(source, target, distance):
		self.source = source
		self.target = target
		self.distance = distance
	
	func test():
		#print(player)
		#var dist = sqrt(pow(self.target.x - self.source.x,2) + pow(self.target.y - self.source.y,2))
		#var dist = sqrt(pow(global.player.x - global.chaser.x,2) + pow(global.player.y - global.chaser.y,2))
		#var dist =  Vector2(target-source).normalized()
		var dist = 150
		print("dist: ",dist)
		print("distance: ",distance)
		return dist < distance