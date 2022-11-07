##ContenedorInformacion.gd

class_name ContenedorInformacion

extends NinePatchRect
#Atributos onready
onready var animaciones: AnimationPlayer = $AnimationPlayer
onready var texto_contenedor:Label = $Label
onready var auto_ocultar_timer: Timer = $AutoOcultarTimer

## Atributos
var esta_activado: bool = true setget set_esta_activado

## Atributos export
export var auto_ocultar: bool = false setget set_auto_ocultar

## Getters and Setters
func set_auto_ocultar(ocultar: bool) -> void:
	auto_ocultar = ocultar

func set_esta_activado(valor: bool) -> void:
	esta_activado = valor


#Metodos
func modificar_texto(text:String) -> void:
	texto_contenedor.text =text
	
## Metodos Personalizados

func mostrar() -> void:
	animaciones.play("Mostrar")

func ocultar() -> void:
	animaciones.play("Ocultar")

func mostrar_suavizado() -> void:
	if not esta_activado:
		return
	animaciones.play("Mostrar_suavizado")
	if auto_ocultar:
		auto_ocultar_timer.start()

func ocultar_suavizado() -> void:
	animaciones.play("Ocultar_suavizado")


func _on_AutoOcultarTimer_timeout():
	ocultar_suavizado()
	
