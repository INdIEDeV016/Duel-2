extends Control


onready var tween = $Tween
onready var lobby_name = $LobbyNameEntry
onready var player_list = $ItemList
onready var transition = $TransitionPanel
onready var info_label = $Info/Label

onready var join_button = $HBoxContainer/JoinButton
onready var host_button = $HBoxContainer/HostButton
onready var start_button = $StartButton


func _ready() -> void:
	tween_in()
	start_button.disabled = true
	
# warning-ignore:return_value_discarded
	GameState.connect("player_list_changed", self, "refresh_player_list")

func _on_HostButton_pressed():
	GameState.host_game()
	host_button.disabled = true
	join_button.disabled = true
	start_button.disabled = false
	
	show_info()
#	var lobby = yield(Gotm.host_lobby(false), "peer_joined")
#	lobby.lobby.hidden = false
#	lobby.lobby.name = lobby_name.text


func _on_JoinButton_pressed():
	GameState.join_game("127.0.0.1")
	start_button.disabled = true
	host_button.disabled = true
	join_button.disabled = true

func _on_Info_popup_hide() -> void:
	hide_info()

func refresh_player_list():
	var players: Array = GameState.get_player_list()
	
	player_list.clear()
	player_list.clear()
	player_list.add_item(GameState.get_player_name() + " (You)")
	for p in players:
		player_list.add_item(p)

	start_button.disabled = not get_tree().is_network_server()


func tween_in():
	var duration: float = 0.3
	tween.interpolate_property(
		player_list, "rect_scale",
		Vector2.RIGHT, Vector2.ONE,
		duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.interpolate_property(
		$HBoxContainer, "rect_position",
		$HBoxContainer.rect_position, Vector2($HBoxContainer.rect_position.x, $HBoxContainer.rect_position.y + $HBoxContainer.rect_size.y + 20),
		duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.interpolate_property(
		lobby_name, "rect_position",
		Vector2(-710, lobby_name.rect_position.y), Vector2(180, lobby_name.rect_position.y),
		duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.interpolate_property(
		$HSeparator, "rect_scale",
		Vector2.ZERO, Vector2.ONE,
		duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.interpolate_property(
		$BackButton, "rect_position",
		Vector2(-$BackButton.rect_size.x - 10, $BackButton.rect_position.y), Vector2(24, $BackButton.rect_position.y),
		duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.interpolate_property(
		$StartButton, "rect_position",
		Vector2(1050, $StartButton.rect_position.y), Vector2(844, $StartButton.rect_position.y),
		duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.interpolate_property(
		$InfoButton, "rect_position",
		Vector2(-165, $InfoButton.rect_position.y), Vector2(24, $InfoButton.rect_position.y),
		duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.start()

func scene_change(scene: String = ""):
	transition.show()
	var duration: float = 0.3
	tween.interpolate_property(
		transition, "color",
		Color(0,0,0,0), Color.black,
		duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_completed")
	if scene.empty():
		GameState.begin_game()
	else:
# warning-ignore:return_value_discarded
		get_tree().change_scene(scene)


func _on_StartButton_pressed() -> void:
	hide_info()
	GameState.begin_game()


func _on_Button_pressed() -> void:
	scene_change("res://Welcome.tscn")


func show_info():
	info_label.get_parent().popup()
	tween.interpolate_property(
		info_label.get_parent(), "rect_position",
		info_label.get_parent().rect_position, Vector2(info_label.get_parent().rect_position.x, 420),
		0.3,
		Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()

func hide_info():
	info_label.get_parent().show()
	tween.interpolate_property(
		info_label.get_parent(), "rect_position",
		info_label.get_parent().rect_position, Vector2(info_label.get_parent().rect_position.x, 665),
		0.3,
		Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_all_completed")
	info_label.get_parent().hide()


func _on_InfoButton_toggled(button_pressed: bool) -> void:
# warning-ignore:standalone_ternary
	show_info() if button_pressed else hide_info()
