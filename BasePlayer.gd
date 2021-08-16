extends KinematicBody2D
class_name BasePlayer

signal dying


export var speed = 750  # speed in pixels/sec
export(PackedScene) var bullet_node: PackedScene = preload("res://Scenes/Bullets/NormalBullet.tscn")

puppet var health = 100 setget set_health
puppet var color: Color = Color()
var velocity = Vector2()
var damaged: float
var pickup_particles = preload("res://Scenes/Particles/Pickup_Particles.tscn")

onready var camera: Camera2D = $"../../Camera2D"

onready var speed_timer = $Timers/Speed
onready var destroy_timer = $Timers/Destroy
onready var area_fire_timer = $Timers/AreaFire
onready var recharge_timer = $Timers/RechargeTimer
onready var acid_timer = $Timers/Acid
onready var shield_timer = $Timers/Shield


func die():
	emit_signal("dying", position, color)
	camera.remove_target(self)
	queue_free()

func _process(_delta: float) -> void:
	if get_tree().network_peer != null: if is_network_master(): rset("health", health)


func damage(amount: float):
	health -= amount
	damaged = amount
	if health <= 0:
		die()


func set_health(value):
	health = value


func pickup_shine(pickup_color: Color):
	var p = pickup_particles.instance()
	p.emitting = true
	p.color = pickup_color
	var tween: = $Tween
	add_child(p)
	
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		get_node_or_null("Box"), "self_modulate",
		pickup_color, color,
		2,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		get_node_or_null("BulletContainer"), "modulate",
		pickup_color, color,
		2,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		get_node_or_null("Name"), "modulate",
		pickup_color, color,
		2,
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
# warning-ignore:return_value_discarded
	tween.start()
