extends KinematicBody2D
var velocity = Vector2()
var MAX_SPEED = 350
var linear_vel = Vector2()
onready var enemy = get_parent().get_node("chaser")
onready var food = get_parent().get_node("food")

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var enemy_pos = enemy.get_pos()
	var distance = sqrt(pow(enemy_pos.x - get_pos().x,2) + pow(enemy_pos.y - get_pos().y,2))
	if distance <= 15:
		get_tree().change_scene("res://Scenes/GameOver.tscn")
		
	var motion = Vector2()
	
	if (Input.is_action_pressed("ui_up")):
		motion += Vector2(0,-1)
		
	if (Input.is_action_pressed("ui_down")):
		motion += Vector2(0,1)
	
	if (Input.is_action_pressed("ui_left")):
		motion += Vector2(-1,0)
	
		
	if (Input.is_action_pressed("ui_right")):
		motion += Vector2(1,0)
	
	if Input.is_action_pressed("arrive") or Input.is_action_pressed("seek"):
		get_node("ray").show()
		global.pressed = true
	else:
		get_node("ray").hide()	
		global.pressed = false
	
	if (Input.is_action_pressed("ui_accept")):
		food.set_pos(get_pos())
		food.show()
		
	motion = motion.normalized()*MAX_SPEED
	velocity = motion
	move(motion*delta)
	