extends Bullet


export var companion_scene = preload("res://Scenes/Companion.tscn")
var collision: Dictionary = {}


func _ready() -> void:
	speed /= 2
	modulate = color

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		collision["normal"] = $RayCast2D.get_collision_normal()
		collision["point"] = $RayCast2D.get_collision_point()
		collision["collider"] = $RayCast2D.get_collider()
#	print(collision_normal)


func _on_CompanionBullet_body_entered(body: Node) -> void:
	if body is Tile or body is TileMap:
		speed = 0
		var companion = companion_scene.instance()
		companion.rotation_degrees = rad2deg(collision["normal"].angle())
		companion.global_position = collision["point"]
		companion.modulate = color
		$"/root/Main/Companion".add_child(companion)
		queue_free()
