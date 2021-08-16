extends Bullet


export var damage: float = 10


func _on_NormalBullet_body_entered(body: Node) -> void:
	if body is KinematicBody2D:
		body.damage(damage)
	if body is Tile:
		body.damage(2)
	queue_free()
