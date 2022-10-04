class_name Player
extends RigidBody2D

## Atributos Export
export var potencia_motor:int = 20
export var potencia_rotacion:int = 20

## Atributos
var empuje: Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

## Métodos
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	#Aplico Empuje empuje.rotated(rotation) pasa a radianes la rotacion del sprite para que afecte al impulso
	apply_central_impulse(empuje.rotated(rotation))


func _process(delta: float) -> void:
	player_input()

## Métodos Custom
func player_input() -> void:
	# Empuje: Si es para adelante o para atras
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje= Vector2(potencia_motor,0)
	elif Input.is_action_pressed("mover_atras"):
		empuje= Vector2(-potencia_motor,0)
	
		# Rotación: simil
	dir_rotacion = 0
	if Input.is_action_pressed("rotar_antihorario"):
		dir_rotacion -=1
	elif Input.is_action_pressed("rotar_horario"):
		dir_rotacion +=1
	

