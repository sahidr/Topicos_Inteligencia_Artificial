extends KinematicBody2D

const MAX_SPEED = 100
const MAX_SPEED_FLEE = 300
const MAX_FORCE = 0.02
const TIME_TO_TARGET = 0.25
const timeToTarget = 0.1
const MAX_ROTATION = deg2rad(360)
const MAX_ACCELERATION = 1000
var velocity = Vector2()
var radius = 420
var target_radius = 50
var slow_radius = 100
var decayCoefficient = 700
var threshold = 700
onready var target = get_pos()
onready var orientation = get_rot()
onready var player = get_parent().get_node("Player")
var move
var wp = Vector2(1433.3333333333333,1750)
var place = Vector2(133.33333333,166.666666667)
func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var steering
	#var separation = separation()
	#if Input.is_action_pressed("arrive"):
	#	steering = arrive()
	#elif Input.is_action_pressed("seek"):
	#	steering = seek()
	#else:
		#steering = approach()
	steering = wander()
	if (steering != null):
		#steering.velocity += separation.velocity
		move(steering.velocity * delta)
#		
func newOrientation(orientation, velocity):
	if (velocity.length() > 0):
		return atan2(-get_pos().x,get_pos().y)
	else:
		return orientation

func approach():
	var distance = Vector2(player.get_pos() - get_pos())
	if distance.length() <= radius:
		return flee()
		
func seek():
	var distance = Vector2(player.get_pos() - get_pos())
	var new_velocity = Vector2(player.get_pos() - get_pos()).normalized() * MAX_SPEED
	var orientation = (distance.angle())
	var steering = KinematicSteeringOutput.new()
	steering.velocity = new_velocity
	velocity = steering.velocity
	steering.orientation = orientation
	set_rot(steering.orientation)
	orientation = 0
	return steering

func seek1():
	var desired_velocity = Vector2(player.get_pos() - get_pos()).normalized() * MAX_SPEED
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * MAX_FORCE)
	return(target_velocity)

func seek2(target):
	var distance = Vector2(target.get_pos() - get_pos())
	var new_velocity = Vector2(target.get_pos() - get_pos()).normalized() * MAX_SPEED
	var orientation = (distance.angle())
	var steering = KinematicSteeringOutput.new()
	steering.velocity = new_velocity
	steering.orientation = orientation
	set_rot(steering.orientation)
	orientation = 0
	return steering


func flee():
	var distance = Vector2(get_pos()-player.get_pos())
	var new_velocity = Vector2(get_pos()-player.get_pos()).normalized() * MAX_SPEED_FLEE
	var orientation = (distance.angle())
	var steering = KinematicSteeringOutput.new()
	steering.velocity = new_velocity
	velocity = steering.velocity
	steering.orientation = orientation
	set_rot(steering.orientation)
	return steering
	
func arrive1():
	var distance = Vector2(player.get_pos() - get_pos())
	var new_velocity = Vector2(player.get_pos() - get_pos()).normalized() * MAX_SPEED
	var steering = KinematicSteeringOutput.new()
	steering.velocity = distance
	steering.orientation = distance.angle() 
	set_rot(steering.orientation)
	if (steering.velocity.length() < radius):
		velocity = steering.velocity
		return steering
	steering.velocity /= TIME_TO_TARGET
	if (steering.velocity.length() > MAX_SPEED):
		steering.velocity = new_velocity
		velocity = steering.velocity
	return steering

func arrive2(target):
	var distance = Vector2(target - get_pos())
	var new_velocity = Vector2(target - get_pos()).normalized() * MAX_SPEED
	var steering = KinematicSteeringOutput.new()
	steering.velocity = distance
	steering.velocity /= TIME_TO_TARGET
	if (steering.velocity.length() > MAX_SPEED):
		steering.velocity = new_velocity
	steering.orientation = distance.angle() 
	set_rot(steering.orientation)
	return steering

func arrive():
	var distance = Vector2(player.get_pos() - get_pos())
	var new_velocity = Vector2(player.get_pos() - get_pos()).normalized() * MAX_SPEED
	var steering = KinematicSteeringOutput.new()
	steering.velocity = distance
	steering.velocity /= TIME_TO_TARGET
	if (steering.velocity.length() > MAX_SPEED):
		steering.velocity = new_velocity
	steering.orientation = distance.angle() 
	set_rot(steering.orientation)
	return steering

func wander():
	var steering = KinematicSteeringOutput.new()
	var rand = randi() % 360
	steering.orientation += rand*20
	set_rot(steering.orientation)
	var direction = Vector2(cos(steering.orientation), sin(steering.orientation))
	steering.velocity = direction.normalized()*MAX_SPEED
	orientation = 0
	velocity = steering.velocity
	return steering
	
	#var direction = Vector2(cos(angle), sin(angle))

func randomBinomial():
	return deg2rad(rand_range(0,360)-rand_range(0,360))

func seekSteering():
	var distance = Vector2(player.get_pos() - get_pos())
	var new_velocity = Vector2(player.get_pos() - get_pos()).normalized() * MAX_ACCELERATION
	var angular = (distance.angle())
	var steering = SteeringOutput.new()
	steering.linear = new_velocity
	steering.angular = angular
	set_rot(steering.angular)
	angular = 0
	return steering

func arriveSteering():
	var direction = Vector2(player.get_pos() - get_pos())
	var distance = direction.length()
	var steering = SteeringOutput.new()
	var targetSpeed
	var targetVelocity
	if (distance < target_radius):
		return null
	if (distance > slow_radius):
		targetSpeed = MAX_SPEED
	else:
		targetSpeed = MAX_SPEED * distance / slow_radius
	targetVelocity = direction
	targetVelocity.normalized()
	targetVelocity *= targetSpeed
	
	steering.linear = targetVelocity - Vector2(player.get_pos())
	steering.linear /= 0.1
	
	if (steering.linear.length() > MAX_ACCELERATION):
		steering.linear.normalized()
		steering.linear *= MAX_ACCELERATION
	steering.angular = 0
	return steering

func separation():
	var nodes = get_nodes_in_group("Cows")
	var steering = KinematicSteeringOutput.new()
	var direction
	var distance
	var strength
	for cows in nodes:
		direction = Vector2(get_pos() - cows.get_pos())
		distance = direction.length()
		if distance < threshold:
			strength = min(decayCoefficient/(distance * distance),MAX_ACCELERATION)
			direction.normalized()
			steering.velocity += strength * direction
	velocity = steering.velocity
	return steering
	
func get_nodes_in_group(group):
	var nodes = []
	var parent = get_parent()
	for node in parent.get_children():
		if node.is_in_group(group):
			nodes.append(node)
	return nodes
	
func arrive_separation():
	var steering = KinematicSteeringOutput.new()
	var arrive = BehaviorAndWeight.new()
	arrive.behavior = arrive()
	arrive.weight = 2
	var separation = BehaviorAndWeight.new()
	separation.behavior = separation()
	separation.weight = 1
	var behaviors = []
	behaviors.append(arrive,separation)
	for behavior in behaviors:
		steering += behavior.weight * behavior.behavior
	steering.velocity = max(steering.velocity, MAX_ACCELERATION)
	steering.orientation = max(steering.orientation, MAX_ROTATION)
	return steering

class SteeringOutput:
	var linear = Vector2()
	var angular = 0.0

class KinematicSteeringOutput:
	var velocity = Vector2()
	var orientation = 0.0

class BehaviorAndWeight:
	var behavior = KinematicSteeringOutput.new()
	var weight = 0