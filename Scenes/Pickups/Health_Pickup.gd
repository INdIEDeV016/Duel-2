extends Pickup


func _on_HealthPickup_body_entered(body: Node) -> void:
	if body is BasePlayer:
		body.health = 100
