extends KinematicBody2D

onready var player = get_parent().get_node("Player")
onready var enemy = get_parent().get_node("Enemy")
var gravity_v = Vector2(0,9.8)
func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if Input.is_action_pressed("shoot"):
		var shoot_velocity = calculateFiringSolution(enemy.get_node("shoot").get_pos(),player.get_pos(),50,gravity_v)
		move(shoot_velocity*delta)
		
func calculateFiringSolution(start,end,muzzle_v,gravity):
	var delta = start - end
	var a  = gravity.dot(gravity)
	var b = -4*((gravity.dot(delta))+muzzle_v*muzzle_v)
	var c = 4*(delta.dot(delta))
	var ttt
	if (4*a*c > b*b):
		return null
	var times0 = sqrt((-b + sqrt(b*b-4*a*c))/(2*a))
	var times1 = sqrt((-b - sqrt(b*b-4*a*c))/(2*a))
	if times0 <0:
		if times1 <0:
			return null
		else:
			ttt = times1
	else:
		if times1 <0:
			ttt = times0
		else:
			ttt = min(times0,times1)
	return (2*delta-gravity*ttt*ttt)/(2*muzzle_v*ttt)
