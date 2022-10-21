class_name MeteoritoSpawner
extends Position2D

#variabes export
export var direccion: Vector2 = Vector2(1, 1)
export var rango_tamanio_meteorito:Vector2 = Vector2(0.5, 2.2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(owner, "ready")
	spawnear_meteorito()
	
func spawnear_meteorito() -> void:
	Eventos.emit_signal("spawn_meteorito", global_position, direccion)

#func tamanio_meteorito_aleatorio() -> float:
#	randomize()
#	return (rand_range(rango_tamanio_meteorito[0], rango_tamanio_meteorito[1]))
