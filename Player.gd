extends BasePlayer
class_name Player


export var friction = 0.09
export var acceleration = 1

var bullets: = 6
puppet var puppet_input: = Vector2()
puppet var puppet_position: = Vector2()
puppet var puppet_rotation: = 0

onready var container = $BulletContainer
onready var placeholder = load("res://ColorRect.tscn")
onready var name_label = $Name

onready var player_name = "Player" setget set_player_name


func _ready():
# warning-ignore:return_value_discarded
	connect("dying", $"../../", "player_death")
	
	
	puppet_position = position
# warning-ignore:narrowing_conversion
	puppet_rotation = rotation_degrees
	
	randomize()
	color = Color.from_hsv(rand_range(0, 1), 1, 1)
	$Box.self_modulate = color
	container.modulate = color
	name_label.add_color_override("font_color", color)
	yield(get_tree().create_timer(2.0), "timeout")
	if is_network_master():
		rset("color", color)
	
	camera.add_target(self)


remote func set_player_name(_name:String):
	player_name = _name
	$Name.text = _name


func set_network_status(properties: Dictionary):
	puppet_input = properties["input"]
	puppet_position = properties["position"]
	puppet_rotation = properties["rotation"]


func get_input() -> Vector2:
	var input = Vector2()
	if is_network_master():
		if Input.is_action_pressed('right'):
			input.x += 1
		if Input.is_action_pressed('left'):
			input.x -= 1
		if Input.is_action_pressed('down'):
			input.y += 1
		if Input.is_action_pressed('up'):
			input.y -= 1

		rpc_unreliable(
			"set_network_status",
			{
				"input" : input,
				"position" : position,
				"rotation" : rotation_degrees
			}
			)
	else:
		input = puppet_input
		position = puppet_position
		rotation_degrees = puppet_rotation
	
	return input


func _process(_delta: float) -> void:
	$Box.self_modulate.v = health/100
	container.modulate.v = health/100

func _physics_process(_delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
	
	if is_network_master():
		look_at(get_global_mouse_position())
		rotation_degrees -= 90
	else:
		puppet_position = position # To avoid jitter
# warning-ignore:narrowing_conversion
		puppet_rotation = rotation_degrees

func _input(event):
	if is_network_master():
		if event.is_action_released("shoot"):
			recharge_timer.paused = true
			camera.shake()
			rpc("shoot", 10)
#		if event.is_action_pressed("shoot", true):
##			super_charge(event)
#			var charge = yield(charge(event), "completed")
#			shoot(charge)
		get_tree().set_input_as_handled()


sync func shoot(_damage: float = 10):
	if bullets > 0:
		var b = Bullet.instance()
		get_node("../../Bullets").add_child(b)
		b.transform = $Muzzle.global_transform
		b.modulate = color
		b.damage = 10
		b.speed += speed
		bullets -= 1
		container.remove_child(container.get_children()[0])
	recharge_timer.paused = false

func charge(event: InputEvent) -> float:
	var charge: float = 10
	recharge_timer.paused = true
	while event.is_action_pressed("shoot", true):
		if not bullets <= 0:
			charge += 1
			container.remove_child(container.get_children()[0])
		yield(get_tree().create_timer(1.0), "timeout")
		if event.is_action_pressed("shoot", true):
			prints("While:", charge)
			return charge
	get_tree().set_input_as_handled()
	recharge_timer.paused = false
	print(charge)
	return charge



func _on_RechargeTimer_timeout():
	if not bullets >= 6:
		bullets += 1
		var p = placeholder.instance()
		container.add_child(p)
		recharge_timer.start()


func _on_VisibilityNotifier2D_viewport_entered(viewport: Viewport) -> void:
	if viewport == get_tree().get_root():
		camera.add_target(self)



func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	if viewport == get_tree().get_root():
#		camera.remove_target(self)
		if is_network_master():
			camera.remove_others(self)
		else:
			camera.remove_target(self)


