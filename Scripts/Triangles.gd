extends Node2D

var grafo = load("res://Scripts/Grafo.gd")

func _ready():
	set_process(true)

func put_waypoints():
	var color = Color(1.0,1.0,0)
	for node in global.w_nodes:
		if node.id =="b" or node.id =="c" or node.id =="g" or node.id =="m" or node.id =="l":
			draw_circle(node.pos,4,color)
			var wp = global.WayPoint.new(node.id,node.pos)
			global.waypoints.append(wp)
			
func draw_triangles(triangles,color):
	var centroid = Vector2()
	var color1 = Color(0.0, 1.0, 1.0)

	#Draw Triangles
	for triangle in global.triangles:
		draw_line(triangle.vertex_1,triangle.vertex_2,color)
		draw_line(triangle.vertex_2,triangle.vertex_3,color)
		draw_line(triangle.vertex_3,triangle.vertex_1,color)
	
		#calculate centroid
		centroid.x = (triangle.vertex_1.x + triangle.vertex_2.x + triangle.vertex_3.x)/3
		centroid.y = (triangle.vertex_1.y + triangle.vertex_2.y + triangle.vertex_3.y)/3
		draw_circle(centroid,2,color1)
		
		var node = grafo.Node.new(triangle.id,centroid)
		global.nodes.append(node)
		
	# Graph Generation
	var from
	var to
	for arc in global.connection_matrix:
		
		for node in global.nodes:
			if (arc[0]==node.id):
				from = node
			if (arc[1]==node.id):
				to = node
		var distance = sqrt(pow((to.pos.x - from.pos.x),2) + pow((to.pos.y - from.pos.y),2))
		var connection = grafo.Connection.new(from,to,distance)
		var connection1 = grafo.Connection.new(to,from,distance)
		global.connections.append(connection)
		global.connections.append(connection1)
			
	global.graph = grafo.Graph.new(global.connections)

func _draw():

	var color = Color(0.0, 1.0, 0.0)
	for vectors in global.vectors_matrix:
		var triangle = global.Triangle.new(vectors)
		global.triangles.append(triangle)
	draw_triangles(global.triangles,color)
	draw_w_graph()
	
func draw_w_graph():
	var color_red = Color(1.0,0.0,0.0)
	var color1 = Color(1.0,1.0,0.0)
	for v in global.v_m:
		var node = grafo.Node.new(v[1],v[0])
		global.w_nodes.append(node)
		draw_circle(v[0],2,color1)
	var from
	var to
	for arc in global.w_c:
		for node in global.w_nodes:
			if (arc[0]==node.id):
				from = node
			if (arc[1]==node.id):
				to = node
		var distance = sqrt(pow((to.pos.x - from.pos.x),2) + pow((to.pos.y - from.pos.y),2))
		var connection = grafo.Connection.new(from,to,distance)
		draw_line(from.get_pos(),to.get_pos(),color_red)
		var connection1 = grafo.Connection.new(to,from,distance)
		global.w_connections.append(connection)
		global.w_connections.append(connection1)
			
	global.w_graph = grafo.Graph.new(global.w_connections)
	put_waypoints()

func _process(delta):
	pass