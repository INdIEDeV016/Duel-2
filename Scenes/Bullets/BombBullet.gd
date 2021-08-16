extends Bullet


export var damage: float = 100

func _ready() -> void:
	$BlastArea.monitoring = false
#	$BlastArea/CollisionShape2D.shape.radius = 0


func _on_BombBullet_body_entered(body: Node) -> void:
	speed = 0
	$BlastArea.monitoring = true
# warning-ignore:return_value_discarded
#	GlobalTween.interpolate_property(
#		$BlastArea/CollisionShape2D.shape, "radius",
#		0, $BlastArea/CollisionShape2D.shape.radius,
#		0.5,
#		Tween.TRANS_LINEAR, Tween.EASE_IN
#		)
#	yield(get_tree().create_timer(0.5), "timeout")
	if body is KinematicBody2D:
		body.damage(damage)
	
	yield(get_tree().create_timer($Icon/CPUParticles2D.lifetime), "timeout")
	queue_free()


func _on_BlastArea_body_entered(body: Node) -> void:
	if body is Tile:
		body.health = 0
