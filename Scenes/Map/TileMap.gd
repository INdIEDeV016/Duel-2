extends TileMap


export(PackedScene) var tile_scene = preload("res://Scenes/Map/Tile.tscn")

var tile_node
var solid_area: Array
var map: Array
var map_borders: Rect2 = get_used_rect()


func _enter_tree() -> void:
	$Tiles.position += cell_size / 2



func set_cellv(_position: Vector2, tile: int = 0, _flip_x: bool = false, _flip_y: bool = false, _transpose: bool = false) -> void:
	match tile:
		-1:
			$Tiles.get_node(String(Vector2(int(_position.x), int(_position.y)))).queue_free()
			return
		0:
			tile_node = tile_scene.instance() #tiles.pop_back()
			tile_node.position = map_to_world(_position, true)
			tile_node.name = String(_position)
		_:
			tile_node = tile_scene.instance() #tiles.pop_back()
			tile_node.position = map_to_world(_position, true)
			tile_node.name = String(_position)
	
	$Tiles.add_child(tile_node)
