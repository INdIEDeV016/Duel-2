extends Pickup


func _on_Acid_Pickup_body_entered(body: Node) -> void:
	if body is BasePlayer:
		body.bullet_node = preload("res://Scenes/Bullets/AcidBullet.tscn")
		body.acid_timer.start()
#		print("\a")
