extends Node2D

var player
var chaser
var point = Vector2(1400,1400)
var pressed = false

###
# Map Graph Constructor
###
var graph
var nodes = []
var connections = []
var triangles = []

var vectors_matrix = [[Vector2(0,0),Vector2(400,0), Vector2(0,500),"a"]
	, [Vector2(400,0)
	, Vector2(0,500)
	, Vector2(300,600),"b"]
	, [Vector2(400,0)
	, Vector2(300,600)
	, Vector2(500,300),"c"]
	, [Vector2(400,0)
	, Vector2(500,300)
	, Vector2(700,100),"d"]
	, [Vector2(500,300)
	, Vector2(700,100)
	, Vector2(800,500),"e"]
	, [Vector2(700,100)
	, Vector2(1000,0)
	, Vector2(800,500),"f"]
	, [Vector2(1000,0)
	, Vector2(800,500)
	, Vector2(1500,600),"g"]
	, [Vector2(800,500)
	, Vector2(1500,600)
	, Vector2(500,900),"h"]
	, [Vector2(500,300)
	, Vector2(500,900)
	, Vector2(300,600),"j"]
	, [Vector2(500,300)
	, Vector2(500,900)
	, Vector2(800,500),"i"]
	, [Vector2(1200,900)
	, Vector2(500,900)
	, Vector2(1500,600),"k"]
	, [Vector2(00,500)
	, Vector2(100,900)
	, Vector2(300,600),"l"]
	, [Vector2(500,900)
	, Vector2(100,900)
	, Vector2(300,600),"m"]
	, [Vector2(1000,00)
	, Vector2(1500,600)
	, Vector2(1500,200),"n"]
	, [Vector2(100,900)
	, Vector2(500,900)
	, Vector2(400,1200),"o"]
	, [Vector2(700,1200)
	, Vector2(500,900)
	, Vector2(400,1200),"p"]
	, [Vector2(700,1200)
	, Vector2(500,900)
	, Vector2(1200,900),"q"]
	, [Vector2(700,1200)
	, Vector2(1300,1100)
	, Vector2(1200,900),"r"]
	, [Vector2(700,1200)
	, Vector2(1300,1100)
	, Vector2(1200,1500),"s"]
	, [Vector2(1300,1100)
	, Vector2(1800,1100)
	, Vector2(1200,1500),"t"]
	, [Vector2(1200,900)
	, Vector2(1500,900)
	, Vector2(1300,1100),"u"]
	, [Vector2(1000,0)
	, Vector2(1500,200)
	, Vector2(1700,0),"y"]
	, [Vector2(1500,600)
	, Vector2(1500,200)
	, Vector2(1700,0),"x"]
	, [Vector2(1700,0)
	, Vector2(1500,600)
	, Vector2(1800,600),"w"]
	, [Vector2(1700,0)
	, Vector2(2000,200)
	, Vector2(1800,600),"z"]
	, [Vector2(1700,0)
	, Vector2(2200,0)
	, Vector2(2000,200),"aa"]
	, [Vector2(2300,500)
	, Vector2(2200,0)
	, Vector2(2000,200),"aaa"]
	, [Vector2(2000,200)
	, Vector2(2100,1100)
	, Vector2(2300,500),"ab"]
	, [Vector2(2000,200)
	, Vector2(2100,1100)
	, Vector2(1800,1100),"ac"]
	, [Vector2(2000,200)
	, Vector2(1800,600)
	, Vector2(1800,1100),"ad"]
	, [Vector2(1500,900)
	, Vector2(1500,600)
	, Vector2(1800,600),"v"]
	, [Vector2(1500,600)
	, Vector2(1500,900)
	, Vector2(1200,900),"ah"]
	, [Vector2(1800,1100)
	, Vector2(1800,600)
	, Vector2(1300,1100),"ae"]
	, [Vector2(1800,1100)
	, Vector2(1600,1400)
	, Vector2(1200,1500),"ag"]
	, [Vector2(100,900)
	, Vector2(0,1200)
	, Vector2(200,1400),"ai"]
	, [Vector2(100,900)
	, Vector2(400,1200)
	, Vector2(200,1400),"ah"]
	, [Vector2(0,1700)
	, Vector2(0,1200)
	, Vector2(200,1400),"aj"]
	, [Vector2(0,1700)
	, Vector2(500,1800)
	, Vector2(200,1400),"ba"]
	, [Vector2(500,1800)
	, Vector2(200,1400)
	, Vector2(400,1200),"ak"]
	, [Vector2(500,1800)
	, Vector2(700,1200)
	, Vector2(400,1200),"al"]
	, [Vector2(700,1200)
	, Vector2(500,1800)
	, Vector2(800,1600),"as"]
	, [Vector2(1200,1500)
	, Vector2(700,1200)
	, Vector2(800,1600),"at"]
	, [Vector2(800,1600)
	, Vector2(1000,1800)
	, Vector2(1200,1500),"au"]
	, [Vector2(1200,1500)
	, Vector2(1000,1800)
	, Vector2(1500,2100),"av"]
	, [Vector2(1200,1500)
	, Vector2(1600,1400)
	, Vector2(1500,2100),"aw"]
	, [Vector2(1600,1400)
	, Vector2(1500,2100)
	, Vector2(2100,1600),"ax"]
	, [Vector2(1600,1400)
	, Vector2(1800,1100)
	, Vector2(2100,1100),"ay"]
	, [Vector2(1600,1400)
	, Vector2(2100,1100)
	, Vector2(2100,1600),"az"]
	]

var connection_matrix = [["a","b",2]
	,["b","c"]
	,["c","d"]
	,["c","j"]
	,["d","e"]
	,["e","f"]
	,["f","e"]
	,["f","g"]
	,["g","h"]
	,["e","i"]
	,["i","h"]
	,["i","j"]
	,["h","k"]
	,["g","n"]
	,["j","m"]
	,["m","l"]
	,["o","p"]
	,["o","m"]
	,["p","q"]
	,["q","r"]
	,["r","s"]
	,["s","t"]
	,["n","y"]
	,["n","x"]
	,["n","w"]
	,["y","x"]
	,["x","w"]
	,["w","z"]
	,["w","v"]
	,["z","aa"]
	,["aaa","ab"]
	,["aa","aaa"]
	,["ad","z"]
	,["ad","ac"]
	,["ac","v"]
	,["v","ah"]
	,["v","o"]
	,["u","ah"]
	,["v","ae"]
	,["ae","u"]
	,["ae","t"]
	,["ac","ag"]
	,["ah","ai"]
	,["o","ah"]
	,["ai","aj"]
	,["k","q"]
	,["ak","ah"]
	,["aj","ba"]
	,["ba","ak"]
	,["ak","al"]
	,["p","al"]
	,["as","at"]
	,["at","aw"]
	,["at","s"]
#	,["at","au"]
	,["au","av"]
	,["av","aw"]
	,["aw","ag"]
	,["as","al"]
	,["ag","ay"]
	,["aw","ax"]
	,["ax","az"]
	,["az","ax"]
	,["s","at"]
	,["t","ag"]
	,["ag","aw"]
	,["ay","az"]
	,["b","l"]
	,["ad","ae"]
	,["ad","ac"]
	,["ae","ac"]
	,["t","ag"]
	,["ae","ay"]
	,["ae","ad"]
	,["w","ad"]
	,["v","w"]
	,["u","r"]
	,["ab","ac"]
	,["k","ah"]
	,["ac","ay"]
	]

class Triangle:
	var vertex_1 = Vector2(0,0)
	var vertex_2 = Vector2(0,0)
	var vertex_3 = Vector2(0,0)
	var center = Vector2(0,0)
	var id
	
	func _init(v):
		self.vertex_1 = v[0]
		self.vertex_2 = v[1]
		self.vertex_3 = v[2]
		self.id = v[3]
	
	func get_id():
		return self.id

func sign1(p1,p2,p3):
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)

func pointInTriangle(pt, triangle):
	var b1
	var b2 
	var b3
	b1 = sign1(pt, triangle.vertex_1, triangle.vertex_2) < 0.0
	b2 = sign1(pt, triangle.vertex_2,triangle.vertex_3) < 0.0
	b3 = sign1(pt, triangle.vertex_3, triangle.vertex_1) < 0.0
	return ((b1 == b2) && (b2 == b3))
	
func get_triangle(pos):
	for t in triangles:
		if pointInTriangle(pos,t):
			return t.get_id()
	return null

###
# WayPoint Graph Constructor
###

var waypoints = []
var w_open = [] #free
var w_closed = []
var w_graph
var w_nodes = []
var w_connections = []
var w_triangles = []

var v_m = [[Vector2(1600,0),"a"]
,[Vector2(1600,200),"b"]
,[Vector2(1800,100),"c"]
,[Vector2(1900,0),"d"]
,[Vector2(2100,100),"e"]
,[Vector2(2200,200),"f"]
,[Vector2(2000,200),"g"]
,[Vector2(1900,300),"h"]
,[Vector2(1900,500),"i"]
,[Vector2(1700,300),"j"]
,[Vector2(1700,500),"k"]
,[Vector2(2000,600),"l"]
,[Vector2(2100,400),"m"]
,[Vector2(2200,500),"n"]
]
var w_c = [["a","b"]
,["a","c"]
,["a","d"]
,["b","c"]
,["b","j"]
,["b","k"]
,["c","d"]
,["c","j"]
,["c","h"]
,["c","g"]
,["d","g"]
,["d","e"]
,["e","g"]
,["e","f"]
,["f","g"]
,["f","m"]
,["f","n"]
,["g","h"]
,["g","m"]
,["h","i"]
,["h","j"]
,["h","k"]
,["h","m"]
,["i","k"]
,["i","m"]
,["i","l"]
,["j","k"]
,["k","l"]
,["l","m"]
,["l","n"]
,["m","n"]
]

class WayPoint:
	var pos
	var id
	var free #false ocupado, true = libre
	func _init(id,pos):
		self.id = id
		self.pos = pos
		self.free = true
	func get_pos():
		return self.pos
	func set_state(state):
		self.free = state
	func is_free():
		return free
	func get_id():
		return self.id