class_name Nivel
extends Node2D

## Atributos Onready
onready var contenedor_proyectiles:Node 

## Metodos

func _ready() -> void:
	conectar_seniales()
	crear_contenedores()
##	Eventos.connect("disparo", self, "_on_disparo")
	
## Metodos Custom
func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")

func crear_contenedores():
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	
func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)
	##add_child(proyectil)


