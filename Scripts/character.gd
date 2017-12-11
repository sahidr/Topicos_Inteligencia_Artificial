extends KinematicBody2D

const MAX_SPEED = 400
const TIME_TO_TARGET = 0.25
var velocity = Vector2()
const RADIUS = 1000
var move
var path
var i = 0
onready var food = get_parent().get_node("food")
onready var player = get_parent().get_node("Player")
var grafo = load("res://Scripts/Grafo.gd")

func _ready():
	set_fixed_process(true)

func getPath(begin,end):
	var begin_node = global.graph.getNode(begin)
	var end_node = global.graph.getNode(end)
	var heuristic = grafo.Heuristic.new(end_node)
	var path = grafo.Graph.pathfindAStar(global.graph,begin_node,end_node,heuristic)
	return path

func location_path(path):
	var from
	var to
	var new_path = []
	for connection in path:
		from = connection.getFromNode().get_pos()
		to = connection.getToNode().get_pos()
		new_path.append(from)
		new_path.append(to)
	return new_path

func seek(target):
	var distance = Vector2(target.get_pos() - get_pos())
	var new_velocity = Vector2(target.get_pos() - get_pos()).normalized() * 150
	var orientation = (distance.angle())
	var steering = KinematicSteeringOutput.new()
	steering.velocity = new_velocity
	steering.orientation = orientation
	set_rot(steering.orientation)
	orientation = 0
	return steering

func arrive(target):
	var distance = Vector2(target.get_pos() - get_pos())
	var new_velocity = Vector2(target.get_pos() - get_pos()).normalized() * MAX_SPEED
	var steering = KinematicSteeringOutput.new()
	steering.velocity = distance
	steering.velocity /= TIME_TO_TARGET
	if (steering.velocity.length() > MAX_SPEED):
		steering.velocity = new_velocity
	steering.orientation = distance.angle() 
	set_rot(steering.orientation)
	return steering

class KinematicSteeringOutput:
	var velocity = Vector2()
	var orientation = 0.0

func _fixed_process(delta):
	var steering
	var direction
	var motion = Vector2()

	var food_pos = food.get_pos()
	var distance = sqrt(pow(food_pos.x - get_pos().x,2) + pow(food_pos.y - get_pos().y,2))
	if distance <= 300 and (not food.is_hidden()):
		steering = seek(food)
		get_parent().get_node("Cow0/Sprite").set_texture(load("res://cow_lat.png"))
		set_z(2)
		move(steering.velocity * delta)
		if distance <=5:
			food.hide()
	else:
		var begin = global.get_triangle(get_pos())
		var end = global.get_triangle(player.get_pos())
		if begin != null && end != null:
			var path = getPath(begin,end)
			if path != []:
				steering = arrive(path.front().getToNode())
				move(steering.velocity * delta)