class_name Nivel
extends Node2D

## Atributos Onready
onready var contenedor_proyectiles:Node 
onready var contenedor_meteoritos: Node
#Atributos export
export var explosion: PackedScene = null
export var meteorito: PackedScene = null
export var explosion_meteorito: PackedScene = null



## Metodos

func _ready() -> void:
	conectar_seniales()
	crear_contenedores()
##	Eventos.connect("disparo", self, "_on_disparo")
	
## Metodos Custom
func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	Eventos.connect("spawn_meteorito", self,"_on_spawn_meteoritos")
	Eventos.connect("meteorito_destruido", self,"_on_meteorito_destruido")
	
	
func crear_contenedores():
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	#Crear contenedores para meteoritos
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "ContenedorMeteoritos"
	add_child(contenedor_meteoritos)
	
	
func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)
	##add_child(proyectil)

func _on_nave_destruida(posicion:Vector2, num_explosiones:int) -> void:
	for i in range(num_explosiones):
		var new_explosion: Node2D = explosion.instance()
		new_explosion.global_position = posicion
		add_child(new_explosion)
		yield(get_tree().create_timer(0.6), "timeout")

func _on_spawn_meteoritos(pos_spawn: Vector2, dir_meteorito: Vector2, tamanio:float) -> void:
	var new_meteorito:Meteorito = meteorito.instance()
	new_meteorito.crear(
		pos_spawn,
		dir_meteorito,
		tamanio
	)
	contenedor_meteoritos.add_child(new_meteorito)

func _on_meteorito_destruido(pos: Vector2) ->void:
	var new_explosion: ExplosionMeteorito = explosion_meteorito.instance()
	new_explosion.global_posicion = pos
	add_child(new_explosion)
#	yield(get_tree().create_timer(0.6), "timeout")
	
	
