extends Control


onready var transition = $CanvasLayer/TransitionPanel
onready var tween = $Tween



func _on_PlayButton_pressed() -> void:
	transition.show()
	scene_change()



func scene_change():
	var duration: float = 0.3
	tween.interpolate_property(
		transition, "color",
		Color(0,0,0,0), Color.black,
		duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_completed")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Lobby.tscn")


func _on_Username_text_changed(new_text):
	GameState.player_name = new_text
