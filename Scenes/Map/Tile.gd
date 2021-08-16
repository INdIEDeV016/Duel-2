extends StaticBody2D
class_name Tile


signal destroyed

var health: float = modulate.a setget set_health


func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("destroyed", get_node("/root/Main"), "tile_destroyed")


func set_health(value: float) -> void:
	modulate.a = value
#	print(modulate.a)
	health = value
	if health <= 0:
		emit_signal("destroyed", self)
		queue_free()


func damage(amount: float) -> void:
	self.health -= amount / 100


func destroy():
	self.health = 0
