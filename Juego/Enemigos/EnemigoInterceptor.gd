## EnemigoInterceptor.gd
class_name EnemigoInterceptor
extends EnemigoBase

## Enums
enum ESTADO_IA {IDLE, ATACANDOQ, ATACANDOP, PERSECUCION}

## Attibs
var estado_ia_actual: int = ESTADO_IA.IDLE
var potencia_actual: float = 0.0

## Atributos export
export var potencia_max: float = 800.0

#Metodos

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity += dir_player.normalized() * potencia_actual * state.get_step()
	
	linear_velocity.x = clamp(linear_velocity.x, -potencia_max, potencia_max)
	linear_velocity.y = clamp(linear_velocity.y, -potencia_max, potencia_max)
	
## mETODOS cUSTOM
func controlador_estado_ia(nuevo_estado: int) -> void:
	match nuevo_estado:
		ESTADO_IA.IDLE:
			canion.set_esta_disparando(false)
			potencia_actual = 0.0
		ESTADO_IA.ATACANDOQ:
			canion.set_esta_disparando(true)
			potencia_actual = 0.0
		ESTADO_IA.ATACANDOP:
			canion.set_esta_disparando(true)
			potencia_actual = potencia_max
		ESTADO_IA.PERSECUCION:
			canion.set_esta_disparando(false)
			potencia_actual = potencia_max
		_:
			print("Error de estado")
	
	estado_ia_actual = nuevo_estado
	
#sEÑALES INTERNAS
# warning-ignore:unused_argument
func _on_AreaDisparo_body_entered(body: Node) -> void:
	controlador_estado_ia(ESTADO_IA.ATACANDOP)

# warning-ignore:unused_argument
func _on_AreaDisparo_body_exited(body: Node) -> void:
	controlador_estado_ia(ESTADO_IA.PERSECUCION)

# warning-ignore:unused_argument
func _on_AreaDeteccion_body_entered(body: Node) -> void:
	controlador_estado_ia(ESTADO_IA.ATACANDOQ)

# warning-ignore:unused_argument
func _on_AreaDeteccion_body_exited(body: Node) -> void:
	controlador_estado_ia(ESTADO_IA.ATACANDOP)
