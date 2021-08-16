extends Camera2D

export var move_speed = 0.5  # camera position lerp speed
export var zoom_speed = 0.25  # camera zoom lerp speed
export var min_zoom = 1.5  # camera won't zoom closer than this
export var max_zoom = 3  # camera won't zoom farther than this
export var margin = Vector2(400, 200)  # include some buffer area around targets

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var targets = []  # Array of targets to be tracked.

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

onready var screen_size = get_viewport_rect().size


func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)


func _process(delta):
	
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	
	if !targets:
		return
	# Keep the camera centered between the targets

	var p = Vector2.ZERO
	for target in targets:
		p += target.position
	p /= targets.size()
	position = lerp(position, p, move_speed)
	# Find the zoom that will contain all targets

	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
#	var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
	else:
		z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)

func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.erase(t)

func remove_others(t):
	if t in targets:
		targets.erase(t)
		targets.push_front(t)
		targets.resize(1)


func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		get_node("../Players/DummyPlayer/Camera2D2").zoom -= Vector2.ONE
	elif event.is_action_pressed("zoom_out"):
		get_node("../Players/DummyPlayer/Camera2D2").zoom += Vector2.ONE
