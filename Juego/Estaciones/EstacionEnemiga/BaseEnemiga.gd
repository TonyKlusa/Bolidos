##BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

## Atribts Export
export var hitpoints: float = 30.0
## Atributos onready
onready var impacto_sfx: AudioStreamPlayer2D = $ImpactoSFX

## Atributos
var esta_destruida: bool = false

##MetodosCustom
func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
		queue_free()
	impacto_sfx.play()


func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aleatoria())

#Que elija algunas de las animaciones	
func elegir_animacion_aleatoria() -> String:
	randomize()
	var num_anim: int = $AnimationPlayer.get_animation_list().size() - 1
	var indice_anim_aleatoria: int = randi() % num_anim +1
	var lista_animacion: Array = $AnimationPlayer.get_animation_list()
	
	return lista_animacion[indice_anim_aleatoria]

func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

func destruir() -> void:
	var posiciones_partes = [
		$Sprites/Sprite.global_position,
		$Sprites/Sprite2.global_position,
		$Sprites/Sprite3.global_position,
		$Sprites/Sprite4.global_position
	]
	
	Eventos.emit_signal("base_destruida",self, posiciones_partes)
#	Eventos.emit_signal("minimapa_objeto_destruido", self)
	queue_free()
