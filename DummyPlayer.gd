extends BasePlayer
class_name Dummyplayer


export var friction = 0.09
export var acceleration = 1

export var player_name = "Player" setget set_player_name

var puppet_input: = Vector2()
var puppet_position: = Vector2()
var puppet_rotation: = 0

var comapnions: int = 3

onready var container = $BulletContainer
onready var bullets: int =  container.get_child_count()
onready var placeholder = load("res://ColorRect.tscn")
onready var name_label = $Name


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
	
	camera.add_target(self)


func set_player_name(_name:String):
	player_name = _name
	$Name.text = _name

func get_input() -> Vector2:
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	
	if Input.is_action_just_pressed("shoot"):
		recharge_timer.paused = true
		shoot()
	
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
	
	look_at(get_global_mouse_position())
	rotation_degrees -= 90


func shoot(_damage: float = 10):
	if bullets > 0:
		var b = bullet_node.instance()
		b.transform = $Muzzle.global_transform
		b.speed += speed
		b.damage = 10
		if b.name == "NormalBullet":
			b.modulate = color
		b.color = color
		get_node("../../Bullets").add_child(b)
		bullets -= 1
		container.remove_child(container.get_children()[0])
	recharge_timer.paused = false

#func charge(event: InputEvent) -> float:
#	var charge: float = 10
#	recharge_timer.paused = true
#	while event.is_action_pressed("shoot", true):
#		if not bullets <= 0:
#			charge += 1
#			container.remove_child(container.get_children()[0])
#		yield(get_tree().create_timer(1.0), "timeout")
#		if event.is_action_pressed("shoot", true):
#			prints("While:", charge)
#			return charge
#	get_tree().set_input_as_handled()
#	recharge_timer.paused = false
#	print(charge)
#	return charge



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
		camera.remove_others(self)


func _on_Username_text_changed(new_text: String) -> void:
	name_label = new_text


func _on_Speed_timeout() -> void:
	speed = 600

func _on_Destroy_timeout() -> void:
	bullet_node = preload("res://Scenes/Bullets/NormalBullet.tscn")

func _on_Acid_timeout() -> void:
	bullet_node = preload("res://Scenes/Bullets/NormalBullet.tscn")

func _on_360Fire_timeout() -> void:
	pass # Replace with function body.




