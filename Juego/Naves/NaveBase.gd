##NaveBase.gd
class_name NaveBase
extends RigidBody2D

##enums
enum ESTADO{SPAWN,VIVO,INVENCIBLE,MUERTO}
## Atributos Export
export var hitpoints:float = 20.0

## Atributos

var estado_actual:int = ESTADO.SPAWN

##Atributos Onready
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var impacto_sfx: AudioStreamPlayer = $Impacto_SFX
onready var canion:Canion = $Canion
onready var barra_salud: ProgressBar = $BarraSalud

## Metodos
func _ready() -> void:
	barra_salud.set_valores(hitpoints)
	controlador_estados(estado_actual)



## Metodos Custom
func controlador_estados(nuevo_estado:int) -> void:
	match nuevo_estado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
			#canion.set_puede_disparar(true) #invencible deberia poder disparar
		ESTADO.MUERTO:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
			Eventos.emit_signal("nave_destruida", self, global_position, 3) #La señal del player que muere activa la explosión
			queue_free()
		_:
			print("error de estado")
			
	estado_actual = nuevo_estado

func recibir_danio(danio: float) -> void:
	
	hitpoints -= danio
	if hitpoints <= 0.0:
		destruir()
	
	barra_salud.controlar_barra(hitpoints, true)
	impacto_sfx.play()



#Señales internas
 #animaciones

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO)

func destruir() -> void:
	controlador_estados(ESTADO.MUERTO)
	
#Destruido por meteorito

func _on_Player_body_entered(body: Node) -> void:
		if body is Meteorito:
#			$AnimationPlayer.play("impacto_meteorito")
			body.destruir()
			destruir()
