extends Area2D
class_name Pickup



var ready_particles = preload("res://Scenes/Particles/PickupReadyParticles.tscn")


func _ready() -> void:
	$Icon.hide()
	$Line2D.hide()
	
	yield(get_tree(), "idle_frame")
	
	var p = ready_particles.instance()
	p.emitting = true
	p.color = $Icon.modulate
	add_child(p)
	yield(get_tree().create_timer(p.lifetime), "timeout")
	p.queue_free()
	
	$Line2D.show()
	$Icon.show()
	GlobalTween.make_tween(
		$Line2D, "scale",
		Vector2.ZERO, $Line2D.scale,
		0.5,
		Tween.TRANS_BACK
	)
	yield(GlobalTween.make_tween(
		$Icon, "scale",
		Vector2.ZERO, $Icon.scale,
		0.5,
		Tween.TRANS_BACK
	), "completed")
	
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_Body_entered")


func _on_Body_entered(body: Node) -> void:
	if body is BasePlayer:
		body.pickup_shine($Icon.modulate)
	queue_free()
