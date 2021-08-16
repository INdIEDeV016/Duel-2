extends Bullet


func _physics_process(delta: float) -> void:
	var collision_normal = $RayCast2D.get_collision_normal()
	rotation_degrees = rad2deg(collision_normal.angle())
