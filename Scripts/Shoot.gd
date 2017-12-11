extends KinematicBody2D

# Member variables
const SPEED = 800

var hit = false


func _ready():
	set_fixed_process(true)

func _fixed_process(delta,velocity):
	translate(velocity*delta)

func shoot(delta,velocity):
	move(delta*velocity)