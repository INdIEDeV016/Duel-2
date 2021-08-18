extends Node2D


var player: BasePlayer
var ready: bool = false

onready var detector = $Detector
onready var barrel = $Base/Barrel


func _ready() -> void:
	detector.set_deferred("monitoring", true)


func _physics_process(delta: float) -> void:
	if player != null and ready:
#		barrel.look_at(player.global_position)
		barrel.rotation_degrees = lerp(barrel.rotation_degrees, rad2deg(get_angle_to(player.global_position)), 0.5)
	else:
		barrel.rotation_degrees = lerp(barrel.rotation_degrees, 0, 0.1)


func _on_Detector_body_entered(body: Node) -> void:
	if body is BasePlayer:
		player = body


func _on_Detector_body_exited(body: Node) -> void:
	if body is BasePlayer:
		player = null


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	ready = true
