extends Pickup


func _on_CompanionPickup_body_entered(body: Node) -> void:
	if body is BasePlayer:
		body.bullet_node = preload("res://Scenes/Bullets/ComapnionBullet.tscn")
