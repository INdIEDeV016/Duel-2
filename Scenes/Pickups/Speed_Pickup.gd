extends Pickup


func _on_SpeedPickup_body_entered(body: Node) -> void:
	if body is BasePlayer:
		body.speed *= 2
		body.speed_timer.start()
