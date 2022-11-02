#EstaciondeRecarga.gd
class_name EstacionDeRecarga
extends Node2D

#Atributos onready
onready var carga_sfx:  AudioStreamPlayer = $CargaSFX

func _ready() -> void:
	$AnimacionEstaciondeRecarga.play("activado")

#Atribs Export
export var energia:float = 6.0 
export var radio_energia_entregada:float = 0.05

##Atributos
var nave_player:Player = null
var player_en_zona: bool = false

#Metodos  
func _unhandled_input(event: InputEvent) -> void:
	if not puede_recargar(event):
		return
	controlar_energia()
#	energia -= radio_energia_entregada

	if event.is_action("recarga_escudo"):
		nave_player.get_escudo().controlar_energia(radio_energia_entregada)
	elif event.is_action("recarga_laser"):
		nave_player.get_laser().controlar_energia(radio_energia_entregada)

#Metodos custom
func puede_recargar(event:InputEvent) -> bool:
	var hay_input = event.is_action("recarga_escudo") or event.is_action("recarga_laser")
	if hay_input and player_en_zona and energia > 0.0:
		if !carga_sfx.playing:
				carga_sfx.play()
		return true
	return false

func controlar_energia()-> void:
	energia -= radio_energia_entregada
	if energia <= 0.0:
		$VacioSFX.play()
	print("energia estacion", energia)

##Señales internas
#Si colisiona con la estacion se destruye
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

#Cuando se acerca al area de recarga, aumenta la gravedad 
func _on_AreaRecarga_body_entered(body: Node) -> void:
	if body is Player:
		player_en_zona = true
		nave_player = body

func _on_AreaRecarga_body_exited(body: Node) -> void:
		if body is Player:
			player_en_zona = false







