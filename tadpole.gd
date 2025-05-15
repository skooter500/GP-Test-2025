@tool

extends Node2D

class_name Tadpole

var length = 5.0
var tadpole_name = ""  # 'name' is reserved in Godot
var w = 50.0
var limbs = 1
var eyes = 2.0
var gender = 'h'
var r = w * 0.5
var eye_radius = w * 0.1
var c1 = 0.0
var c2 = 0.0
var fatness = 1.0
var speed = 0.0
var alpha = 127.0
var cw = 50.0

# Name combos is missing in the original code, so I'll define it here
var name_combos = ["foo", "bar", "baz", "qux"]  # Replace with your actual name combinations

func _init(p_length = 0, p_name = "", p_limbs = 0, p_eyes = 0, p_gender = ""):
	if p_length != 0:  # If parameters provided
		length = p_length
		tadpole_name = p_name
		limbs = p_limbs
		eyes = p_eyes
		gender = p_gender
	else:
		randomise()

func _ready() -> void:
	randomise()

func _process(delta: float) -> void:
	queue_redraw()

func randomise():
	# Use randi() % n for integers
	limbs = randi() % 5
	eyes = randi() % 9
	
	var genders = ['m', 'f', 'h', 'n']
	gender = genders[randi() % genders.size()]
	
	var name_length = 1 + randi() % 4  # Equivalent to random(1, 5)
	tadpole_name = ""
	for i in range(name_length):
		tadpole_name += name_combos[randi() % name_combos.size()] + " "
	
	# Remove trailing space
	tadpole_name = tadpole_name.strip_edges()
	
	print(self)

# Equivalent to map() in Processing
func map_value(value, start1, stop1, start2, stop2):
	return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))

# Equivalent to pingpongmap() which seems to be a custom function in the original code
func pingpongmap(value, start1, stop1, start2, stop2):
	var mapped = map_value(value, start1, stop1, 0, 1)
	var ping_pong = 1.0 - abs(2.0 * mapped - 1.0)
	return map_value(ping_pong, 0, 1, start2, stop2)

# Godot's builtin draw function
func _draw():
	render(position.x, position.y, 0)

func render(cx, cy, offs):
	c2 = c1 + cw

	var half = w * length * 0.5
	
	# Save current transform state
	var prev_transform = get_transform()
	
	# Create a new transform for drawing
	var canvas_transform = Transform2D()
	canvas_transform = canvas_transform.translated(Vector2(cx, cy - half))
	
	# Apply the transform for drawing
	draw_set_transform(canvas_transform.origin, canvas_transform.get_rotation(), canvas_transform.get_scale())
	
	for i in range(length):
		var color_val = int(pingpongmap(i, 0, (length - 1) * 0.5, c1, c2)) % 255
		var stroke_color = Color(color_val / 255.0, 1, 1, alpha / 255.0)
		
		var y = i * w
		var f = 0.5
		var w1 = sin(map_value(i, 0, length, f + f, PI)) * fatness
		
		# Draw ellipse
		draw_ellipse(Vector2(0, y), Vector2(w1 * 2.0, w), stroke_color)
		
		if limbs > 0 and i > 0:
			# Draw limbs
			draw_line(Vector2(-w1, y), Vector2(-w1 - w1, y), stroke_color, 3)
			draw_line(Vector2(w1, y), Vector2(w1 * 2, y), stroke_color, 3)
			draw_circle(Vector2(-w1 * 2.0 - eye_radius, y), eye_radius, stroke_color)
			draw_circle(Vector2(w1 * 2.0 + eye_radius, y), eye_radius, stroke_color)
		
		if i == 0:
			draw_eyes(eyes, w1, w * 0.5, stroke_color)
	
	draw_genitals()
	
	# Restore original transform
	draw_set_transform(prev_transform.origin, prev_transform.get_rotation(), prev_transform.get_scale())

func draw_genitals():
	var stroke_color = Color(1, 1, 1, alpha / 255.0)  # Default color
	
	match gender:
		'm':
			var y = ((length - 1) * w) + (w * 0.5)
			draw_line(Vector2(0, y), Vector2(0, y + r), stroke_color, 3)
			draw_circle(Vector2(0, y + r + eye_radius), eye_radius, stroke_color)
		'f':
			var y = (length - 1) * w
			draw_circle(Vector2(0, y), eye_radius * 2.0, stroke_color)
		'h':
			var y1 = (length * w) - r
			draw_line(Vector2(0, y1), Vector2(0, y1 + r), stroke_color, 3)
			draw_circle(Vector2(0, y1 + r + eye_radius), eye_radius, stroke_color)
			
			var y = ((length - 1) * w) + (w * 0.5)
			draw_line(Vector2(0, y), Vector2(0, y + r), stroke_color, 3)
			draw_circle(Vector2(0, y + r + eye_radius), eye_radius, stroke_color)

func _to_string():
	return "Tadpole [c1=" + str(c1) + ", c2=" + str(c2) + ", eye_radius=" + str(eye_radius) + \
		   ", eyes=" + str(eyes) + ", gender=" + gender + ", length=" + str(length) + \
		   ", limbs=" + str(limbs) + ", name=" + tadpole_name + ", r=" + str(r) + ", w=" + str(w) + "]"

func draw_eyes(num_eyes, hw, hh, color):
	var offs = 90.0 / num_eyes
	
	for i in range(num_eyes):
		var angle = map_value(i, 0, num_eyes, -90, 90) + offs
		var stalk_length = r * 0.25 + (sin(map_value(angle, -90, 90, 0, PI)) * r * 4)
		draw_eye(angle, stalk_length, hw, hh, color)

func draw_eye(angle, stalk_length, head_w, head_h, color):
	var x1 = sin(deg_to_rad(angle)) * head_w
	var y1 = -cos(deg_to_rad(angle)) * head_h
	
	var x2 = sin(deg_to_rad(angle)) * (head_w + stalk_length)
	var y2 = -cos(deg_to_rad(angle)) * (head_h + stalk_length)
	
	var ex = sin(deg_to_rad(angle)) * (head_w + stalk_length + eye_radius)
	var ey = -cos(deg_to_rad(angle)) * (head_h + stalk_length + eye_radius)
	
	draw_circle(Vector2(ex, ey), eye_radius, color)
	draw_line(Vector2(x1, y1), Vector2(x2, y2), color, 3)

# Helper function to draw ellipse (Godot doesn't have a built-in ellipse drawing function)
func draw_ellipse(center, size, color):
	var num_points = 24
	var points = PackedVector2Array()
	
	for i in range(num_points + 1):
		var angle = i * 2 * PI / num_points
		var x = center.x + cos(angle) * size.x * 0.5
		var y = center.y + sin(angle) * size.y * 0.5
		points.append(Vector2(x, y))
	
	for i in range(points.size() - 1):
		draw_line(points[i], points[i + 1], color, 3)
