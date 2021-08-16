extends Pickup


func _on_DestroyPickup_body_entered(body: Node) -> void:
	if body is BasePlayer:
		body.bullet_node = preload("res://Scenes/Bullets/BombBullet.tscn")
		body.destroy_timer.start()
