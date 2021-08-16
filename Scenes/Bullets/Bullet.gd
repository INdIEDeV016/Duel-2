extends Area2D
class_name Bullet


export var speed = 750
export(Color) var color: Color


# warning-ignore:unused_signal
signal explode

func _ready():
# warning-ignore:return_value_discarded
	connect("explode", $"../..", "explosion")
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_Body_entered")

func _physics_process(delta):
	position += transform.x * speed * delta


# warning-ignore:unused_argument
func _on_Body_entered(body: Node) -> void:
	emit_signal("explode", position, color)
