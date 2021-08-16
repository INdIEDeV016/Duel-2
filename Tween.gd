extends Tween


func make_tween(
	object: Object, property: String,
	from, to,
	duration: float = 1,
	transition: int = Tween.TRANS_QUART, easing: int = Tween.EASE_OUT,
	delay: float = 0
) -> void:
# warning-ignore:return_value_discarded
	interpolate_property(
		object, property,
		from, to,
		duration,
		transition, easing,
		delay
	)
	
# warning-ignore:return_value_discarded
	start()
	
	yield(self, "tween_all_completed")
