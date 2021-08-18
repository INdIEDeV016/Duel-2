extends Bullet


export var damage: float = 10


func _ready() -> void:
	modulate = color


func _on_NormalBullet_body_entered(body: Node) -> void:
	if body is KinematicBody2D:
		body.damage(damage)
	if body is Tile:
		body.damage(damage / 5)
	queue_free()
