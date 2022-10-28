#SectorDEpeligro.gd
extends Area2D

#Attrib for export
export (String, "Vacio", "Meteorito","Enemigo") var tipo_peligro
export var numeros_peligro: int  = 10

#Señales


func _on_body_entered(_body: Node) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(0.1), "timeout")
	enviar_senial()
	
func enviar_senial() -> void:
	Eventos.emit_signal("nave_en_sector_peligro", $PosicionCentroSector.global_position,
	tipo_peligro,
	numeros_peligro)
	queue_free()
	
