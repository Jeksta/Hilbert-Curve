class_name HilbertCurve

# Iterative algorithm for drawing Hilbert curve
# (https://marcin-chwedczuk.github.io/iterative-algorithm-for-drawing-hilbert-curve)

const HILBERT_POINTS: Array = [
	Vector2(0,0),
	Vector2(0,1),
	Vector2(1,1),
	Vector2(1,0)
]


# returns the execution time in usec
# (Just for testing purposes)
static func get_execution_time(order: int, size: Vector2) -> int:
	var start_time: int = OS.get_ticks_usec()
	get_path(order, size)
	return OS.get_ticks_usec() - start_time


# Calculates the curve path for a given order
static func get_path(order: int, size: Vector2, streched: bool=false) -> PoolVector2Array:
	# N is the number of rows and columns
	var N: int = int(pow(2, order))
	var total: int = N * N
	
	if streched:
		var min_size = min(size.x, size.y)
		size = Vector2(min_size, min_size)
		
	var cell_size: Vector2 = size / N
	var center_offset: Vector2 = cell_size / 2
	
	var path: PoolVector2Array = []
	for i in range(total):
		var next_point: Vector2 = index_to_xy(i, order)
		next_point *= cell_size
		next_point += center_offset
		path.append(next_point)
		
	return path


# Finds the map xy coordinates of the next path point
static func index_to_xy(i: int, order: int) -> Vector2:
	var N: int = 1
	var xy: Vector2 = HILBERT_POINTS[i & 3]
	
	for _i in range(1, order):
		i = i >> 2
		N = N << 1
		
		match i & 3:
			0: # left-bottom
				xy = Vector2(xy.y, xy.x)
			1: # left-top
				xy += Vector2(0, N)
			2: # right-top
				xy += Vector2(N, N)
			3: # right-bottom
				xy = Vector2(2 * N - 1 - xy.y, N - 1 - xy.x)
		
	return xy
