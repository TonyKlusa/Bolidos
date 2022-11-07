##ContenedorInformacion.gd

class_name ContenedorInformacion

extends NinePatchRect
#Atributos onready
onready var animaciones: AnimationPlayer = $AnimationPlayer
onready var texto_contenedor:Label = $Label
onready var auto_ocultar_timer: Timer = $AutoOcultarTimer


#Metodos
func modificar_texto(text:String) -> void:
	texto_contenedor.text =text
	
## Metodos Personalizados

func mostrar() -> void:
	animaciones.play("mostrar")

func ocultar() -> void:
	animaciones.play("ocultar")

func mostrar_suavizado() -> void:
	animaciones.play("Mostrar_suavizado")

func ocultar_suavizado() -> void:
	animaciones.play("Ocultar_suavizado")




func _on_AutoOcultarTimer_timeout():
	ocultar_suavizado()
	
