extends Node2D


var particles = preload("res://Scenes/Particles/Bullet_Blast.tscn")
var player_death_particles = preload("res:///Scenes/Particles/Player_Death.tscn")
var tile_destroy_particles = preload("res://Scenes/Particles/TileDestroyParticles.tscn")

var map: PoolVector2Array


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func explosion(pos, color):
	var p = particles.instance()
	p.position = pos
	p.color = color
	add_child(p)
	p.emitting = true
	yield(get_tree().create_timer(p.lifetime), "timeout")
	p.queue_free()

func player_death(pos, color):
	var p = player_death_particles.instance()
	p.position = pos
	p.color = color
	add_child(p)
	p.emitting = true
	yield(get_tree().create_timer(p.lifetime), "timeout")
	p.queue_free()

func tile_destroyed(tile: Tile):
	var p = tile_destroy_particles.instance()
	p.global_position = tile.global_position
	p.color = $TileMap.modulate
	add_child(p)
	p.emitting = true
	yield(get_tree().create_timer(p.lifetime), "timeout")
	p.queue_free()
	
