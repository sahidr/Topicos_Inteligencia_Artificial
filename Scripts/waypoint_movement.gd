extends KinematicBody2D

const MAX_SPEED = 300
const TIME_TO_TARGET = 0.25
var velocity = Vector2()
const RADIUS = 70
var place = Vector2(133.33333333,166.666666667)
var move
var path
var i = 0
var run = false
var begin
var end
var path_found = false
var is_chasing = false
var wp = Vector2(2000,200)
onready var player = get_parent().get_node("Player")
var grafo = load("res://Scripts/Grafo.gd")

func _ready():
	set_fixed_process(true)

func running():
	var player_pos = player.get_pos()
	var distance = sqrt(pow(player_pos.x - get_pos().x,2) + pow(player_pos.y - get_pos().y,2))
	if distance < RADIUS && distance >12:
		run = true
		if not path_found:
			begin = get_waypoint()
			end = find_free_waypoint()
			if (begin !=null and end != null):
				path = getPath(begin.id,end.id)
				if path != null or path !=[]:
					path_found = true
	elif distance <= 12:
		is_chasing = false
func getPath(begin,end):
	var begin_node = global.w_graph.getNode(begin)
	var end_node = global.w_graph.getNode(end)
	#var path = grafo.Graph.pathfindDijkstra(global.graph,begin,end)
	var heuristic = grafo.Heuristic.new(end_node)
	var path = grafo.Graph.pathfindAStar(global.w_graph,begin_node,end_node,heuristic)
	#var cartessian_path = location_path(path)
	#return cartessian_path
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
	var new_velocity = Vector2(target.get_pos() - get_pos()).normalized() * 350
	var orientation = (distance.angle())
	var steering = KinematicSteeringOutput.new()
	steering.velocity = new_velocity
	steering.orientation = orientation
	set_rot(steering.orientation)
	orientation = 0
	return steering

func velocity_matching(target):
	var steering = KinematicSteeringOutput.new()
	steering.velocity = target.velocity

func get_waypoint():
	for w in global.waypoints:
		var distance = sqrt(pow(w.get_pos().x - get_pos().x,2) + pow(w.get_pos().y - get_pos().y,2))
		if distance <= 10:
			w.set_state(false)
			return w
	return null

class KinematicSteeringOutput:
	var velocity = Vector2()
	var orientation = 0.0

func find_free_waypoint():
	for w in global.waypoints:
		if w.is_free():
			return w
	return null
	
func arrive(target):
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


func _fixed_process(delta):

	var steering
	var direction
	var motion = Vector2()
	
	if is_chasing:
		running()
		if run:
			if (i<=path.size()) and (get_pos() != path[i].getToNode().get_pos()):
				steering = seek(path[i].getToNode())
				move(steering.velocity * delta)
				i += delta
			else:
				if (begin !=null and end != null):
					begin.set_state(true)
					end.set_state(false)
				run = false
				path_found = false
				i = 0
			if (begin !=null and end != null):
				begin.set_state(true)
				end.set_state(false)
	else:
		var player_pos = player.get_pos()
		var distance = sqrt(pow(player_pos.x - get_pos().x,2) + pow(player_pos.y - get_pos().y,2))
		var place_distance = sqrt(pow(place.x - get_pos().x,2) + pow(place.y - get_pos().y,2))
		if distance < 150 && global.pressed:
			steering = seek(player)
			set_z(2)
			move(steering.velocity * delta)
			
		elif (not global.pressed) && place_distance<500:
			steering = arrive(place)
			move(steering.velocity * delta)
		elif (not global.pressed) && place_distance>=500:
			steering = arrive(wp)
			move(steering.velocity * delta)
			is_chasing = true