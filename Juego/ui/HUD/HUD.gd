##HUD.gd
class_name HUD
extends CanvasLayer

#atrib onrady
onready var info_zona_recarga: ContenedorInformacion = $InfoZonaRecarga
onready var info_meteoritos : ContenedorInformacion = $InfoMeteoritos


func _ready() -> void:
	conectar_seniales()

func conectar_seniales()-> void:
	Eventos.connect("nivel_iniciado",self, "fade_out")
	Eventos.connect("nivel_terminado", self,"fade_in")
	Eventos.connect("detecto_zona_recarga", self,"_on_detecto_zona_recarga")
	Eventos.connect("cambio_numero_meteoritos", self, "_on_actualizar_info_meteoritos")
## Metodos custom	
func fade_in() -> void:
	$FadeCanvas/AnimationPlayer.play("fade_in")

func fade_out() -> void:
	$FadeCanvas/AnimationPlayer.play_backwards("fade_in")

func _on_detecto_zona_recarga(en_zona: bool) -> void:
	if en_zona:
		info_zona_recarga.mostrar_suavizado()
	else:
		info_zona_recarga.ocultar_suavizado()	

func _on_actualizar_info_meteoritos(numero:int) -> void:
	info_meteoritos.mostrar_suavizado()
	info_meteoritos.modificar_texto(
		"METEORITOS RESTANTES\n {Cantidad}".format({"Cantidad":numero})
	)
	
