extends Bullet


export var damage: float = 16


func _on_AcidBullet_body_entered(body: Node) -> void:
	set_deferred("monitoring", false)
	if body is KinematicBody2D:
		body.damage(damage)
	speed = 0
	if body is Tile:
		body.damage(47)
	yield(get_tree().create_timer($Icon/CPUParticles2D.lifetime), "timeout")
	queue_free()
