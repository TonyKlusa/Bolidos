##Escudo.gd
class_name Escudo
extends Area2D

##Variables
var esta_activado: bool = false setget, get_esta_activado
var energia_original:float


#variables export
export var energia:float = 18
export var radio_desgaste:float = -0.6

## Setter y getters
func get_esta_activado() -> bool:
	return esta_activado

##Metodos 
func _ready() -> void:
	energia_original = energia
	set_process(false)
	controlar_colisionador(true)
	
	
func _process(delta: float) -> void:
	#Controla la energia del Laser
	controlar_energia(radio_desgaste * delta)
	
	
	if energia <= 0.0:
		desactivar()
	
##metodos custom
func controlar_colisionador(esta_desactivado: bool ) -> void:
	$CollisionShape2D.set_deferred("disabled", esta_desactivado)
	
func activar() -> void:
	print("activar")
	esta_activado = true
	controlar_colisionador(false)
	$AnimationPlayer.play("activando")
	set_process(true)
	
func desactivar() -> void:
	set_process(false)
	esta_activado = false
	controlar_colisionador(true)
	$AnimationPlayer.play_backwards("activando")
	
## señales internas

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "activando" and esta_activado:
		$AnimationPlayer.play("activado")
		set_process(true)

#
#Revisar las animaciones del force field
#
#

func _on_body_entered(body: Node) -> void:
	body.queue_free()

#Eneegia
func controlar_energia(consumo:float)->void:
	energia += consumo
	print("energia escudo", energia)
	if energia > energia_original:
		energia = energia_original
	elif energia <= 0.0:
		desactivar()

		
