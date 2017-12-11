class NodeRecord:
	var node
	var connection
	var cost
	var estimatedTotalCost

	func full(node,connection,costSoFar):
		self.node = node
		self.connection = connection
		self.cost = costSoFar
	
class Node:
	var id
	var pos
	
	func _init(id,pos):
		self.id = id
		self.pos = pos
		
	func setPos(pos):
		self.pos = pos
	
	func get_pos():
		return self.pos

class Connection:
	var fromNode
	var toNode
	var cost
	
	func _init(from,to,cost):
		self.fromNode = from
		self.toNode = to
		self.cost = cost
	
	func getCost():
		return self.cost
	
	func getFromNode():
		return self.fromNode
		
	func getToNode():
		return self.toNode

class Graph:
		
	static func findNodeRecord(list, node):
		for elem in list:
			if elem.node == node:
				return elem

	func containsNodeRecord(list, node):
		for elem in list:
			if elem.node == node:
				return true
		 return false
	
	var connections
	
	func _init(connections):
		self.connections = connections
	
	func getConnections(fromNode):
		var connectionsfromNode = []
		for connection in connections:
			if (fromNode == connection.getFromNode()):
				connectionsfromNode.append(connection)
		return connectionsfromNode
	
	var pathfindinglist = []
	
	func getNode(id):
		for connection in connections:
			var from = connection.getFromNode()
			var to = connection.getToNode()
			if (from.id == id):
				return from
			elif (to.id == id):
				return to
		return null

	func smoothPath(inputPath):
# If the path is only two nodes long, then
# we can’t smooth it, so return
		if len(inputPath) == 2: 
			return inputPath
		# Compile an output path
		var outputPath = [inputPath[0]]
		# Keep track of where we are in the input path
		# We start at 2, because we assume two adjacent
		# nodes will pass the ray cast
		var inputIndex = 2
		# Loop until we find the last item in the input
		while (inputIndex < len(inputPath)-1):
		# Do the ray cast
			if not rayClear(outputPath[len(outputPath)-1],inputPath[inputIndex]):
		# The ray text failed, add the last node that
		# passed to the output list
				outputPath += inputPath[inputIndex-1]
		# Consider the next node
			inputIndex+=1
		# We’ve reached the end of the input path, add the
		# end node to the output and return it
		outputPath += inputPath[len(inputPath)-1]
		return outputPath

	static func smallestElementDijsktra(nodeRecordList):
		var smallest = nodeRecordList.front()
		for node in nodeRecordList:
			if (node.cost < smallest.cost):
				smallest = node
		return smallest
		
	static func smallestElemenAStar(nodeRecordList):
		var smallest = nodeRecordList.front()
		for node in nodeRecordList:
			if (node.estimatedTotalCost < smallest.estimatedTotalCost):
				smallest = node
		return smallest
		
	static func pathfindAStar(graph, start, end, heuristic):
	# This structure is used to keep track of the
	# information we need for each node
	#Initialize the record for the start node
		var startRecord = NodeRecord.new()
		startRecord.full(start,null,0)
		startRecord.estimatedTotalCost = heuristic.estimate(start)
		var endNode
		var endNodeCost
		var endNodeRecord
		var current
		var endNodeHeuristic
		
		# Initialize the open and closed lists
		var open = []
		open.append(startRecord)
		var closed = []
		
		# Iterate through processing each node
		while (open.size() > 0):
			
			# Find the smallest element in the open list
			current = smallestElemenAStar(open)
			# If it is the goal node, then terminate
			if current.node == end: break
			# Otherwise get its outgoing connections
			var connections = graph.getConnections(current.node)
			# Loop through each connection in turn
			for connection in connections:
			# Get the cost estimate for the end node
				#endNode = NodeRecord.new(connection.getToNode(),null,0)
				endNode = connection.getToNode()
				endNodeCost = current.cost + connection.getCost()
				#endNode.costSoFar = endNodeCost
			# Skip if the node is closed
				if graph.containsNodeRecord(closed,endNode):
					
					endNodeRecord = findNodeRecord(closed,endNode)
					
					if endNodeRecord.cost <= endNodeCost: continue
					closed.erase(endNodeRecord)
					endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.cost
					
			# .. or if it is open and we’ve found a worse
			# route
				elif graph.containsNodeRecord(open,endNode):
			# Here we find the record in the open list
			# corresponding to the endNode.
					endNodeRecord = findNodeRecord(open,endNode)
					if endNodeRecord.cost <= endNodeCost: continue
					endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.cost
			# Otherwise we know we’ve got an unvisited
			# node, so make a record for it
				else:
					endNodeRecord = NodeRecord.new()
					endNodeRecord.node = endNode
					endNodeHeuristic = heuristic.estimate(endNode)
			# We’re here if we need to update the node
			# Update the cost and connection
				
				endNodeRecord.cost = endNodeCost
				endNodeRecord.connection = connection
				endNodeRecord.estimatedTotalCost = endNodeCost + endNodeHeuristic
			# And add it to the open list
				if not graph.containsNodeRecord(open,endNode):
					open.append(endNodeRecord)
		# We’ve finished looking at the connections for
		# the current node, so add it to the closed list
		# and remove it from the open list
			open.erase(current)
			closed.append(current)
			# We’re here if we’ve either found the goal, or
			# if we’ve no more nodes to search, find which.
		if current.node != end:
	
		# We’ve run out of nodes without finding the
		# goal, so there’s no solution
			return null
		else:
		# Compile the list of connections in the path
			var path = []
		# Work back along the path, accumulating
		# connections
			while current.node != start:
				path.append(current.connection)
				var fromNode = current.connection.getFromNode()
				current = graph.findNodeRecord(closed,fromNode)
		# Reverse the path, and return it
			path.invert()
			return path

	static func print_path(path):
		var list = []
		var list1 = []
		for c in path:
			list.append(c.getFromNode().id)
			list.append('->')
			list.append(c.getToNode().id)
			list1.append(c.getFromNode().get_pos())
			list1.append('->')
			list1.append(c.getToNode().get_pos())
		print(list)
		print(list1)
		
	func pathfindDijkstra(graph, start, end):
	# This structure is used to keep track of the
	# information we need for each node
	#Initialize the record for the start node
		var startRecord = NodeRecord.new()
		startRecord.full(start,null,0)
		var endNode
		var endNodeCost
		var endNodeRecord
		var current
		
		# Initialize the open and closed lists
		var open = []
		open.append(startRecord)
		var closed = []
		
		# Iterate through processing each node
		while (open.size() > 0):
			
			# Find the smallest element in the open list
			current = smallestElementDijkstra(open)
			# If it is the goal node, then terminate
			if current.node == end: break
			# Otherwise get its outgoing connections
			var connections = graph.getConnections(current.node)
			# Loop through each connection in turn
			for connection in connections:
			# Get the cost estimate for the end node
				endNode = connection.getToNode()
				endNodeCost = current.cost + connection.getCost()
				#endNode.costSoFar = endNodeCost
			# Skip if the node is closed
				if graph.containsNodeRecord(closed,endNode):
					continue
			# .. or if it is open and we’ve found a worse
			# route
				elif graph.containsNodeRecord(open,endNode):
			# Here we find the record in the open list
			# corresponding to the endNode.
					endNodeRecord = findNodeRecord(open,endNode)
					if endNodeRecord.cost <= endNodeCost: continue
			# Otherwise we know we’ve got an unvisited
			# node, so make a record for it
				else:
					endNodeRecord = NodeRecord.new()
					endNodeRecord.node = endNode
			# We’re here if we need to update the node
			# Update the cost and connection
				endNodeRecord.cost = endNodeCost
				endNodeRecord.connection = connection
			# And add it to the open list
				if not graph.containsNodeRecord(open,endNode):
					open.append(endNodeRecord)
		# We’ve finished looking at the connections for
		# the current node, so add it to the closed list
		# and remove it from the open list
			open.erase(current)
			closed.append(current)
			# We’re here if we’ve either found the goal, or
			# if we’ve no more nodes to search, find which.
		if current.node != end:
	
		# We’ve run out of nodes without finding the
		# goal, so there’s no solution
			return null
		else:
		# Compile the list of connections in the path
			var path = []
		# Work back along the path, accumulating
		# connections
			while current.node != start:
				path.append(current.connection)
				var fromNode = current.connection.getFromNode()
				current = graph.findNodeRecord(closed,fromNode)
		# Reverse the path, and return it
			path.invert()
			return path
	
class Heuristic:
# Stores the goal node that this heuristic is
# estimating for
	var goalNode
# Constructor, takes a goal node for estimating.
	func _init(goal):
		self.goalNode = goal
# Generates an estimated cost to reach the
# stored goal from the given node
	func estimate(node):
		var distance = sqrt(pow(self.goalNode.get_pos().x - node.get_pos().x,2) + pow(self.goalNode.get_pos().y - node.get_pos().y,2))
		return distance