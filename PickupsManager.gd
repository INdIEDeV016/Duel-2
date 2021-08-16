extends Node2D


export(Array) var pickups: Array = []
export(String) var pickups_dir: String = "res://Scenes/Pickups/"

onready var tile_map = owner.get_node("TileMap")


func _ready() -> void:
	for child in get_children():
		if child is Pickup:
			yield(get_tree(), "idle_frame")
			child.position = tile_map.map_to_world(tile_map.map[randi() % tile_map.map.size()])
	
	var d = Directory.new()
	if d.open(pickups_dir) == OK:
		d.list_dir_begin()
		var file = d.get_next()
		while not file.empty():
			if file.ends_with("Pickup.tscn") and not d.current_is_dir():
				yield(get_tree(), "idle_frame")
				pickups.append(load(pickups_dir + file).instance())
			file = d.get_next()
	else:
		push_error("PickupManager.gd | An error occured while loading Pickups")
	
	print(pickups)
	


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if get_child_count() <= 3:
		var pickup: Pickup = pickups[(randi() % pickups.size())].duplicate(8)
		if is_instance_valid(pickup):
			pickup.position = tile_map.map_to_world(tile_map.map[randi() % tile_map.map.size()])
			call_deferred("add_child", pickup)
#			print("Added Pickup")
