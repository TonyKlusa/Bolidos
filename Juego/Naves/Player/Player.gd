##Player.gd
class_name Player
extends NaveBase

## Atributos Export
export var potencia_motor:int = 18
export var potencia_rotacion:int = 260
export var estela_maxima:int = 150

## Atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

##Atributos Onready
onready var estela:Estela = $EstelaPuntoInicio/Trail2D
onready var laser:RayoLaser = $LaserBeam2D setget, get_laser
onready var escudo : Escudo = $Escudo setget, get_escudo
onready var motor_sfx:Motor = $MotorSFX

##Setters y getters 
func get_laser() -> RayoLaser:
	return laser
func get_escudo() -> Escudo:
	return escudo

#Metodos
func _ready() -> void:
	controlador_estados(estado_actual)
	DatosJuego.set_player_actual(self)
	
func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return
	#Disparo Rayo secundario
	if event.is_action_pressed("disparo secundario"):
		laser.set_is_casting(true)
		
	if event.is_action_released("disparo secundario"):
		laser.set_is_casting(false)
## control estela
	if event.is_action_pressed("mover_adelante"):
		estela.set_max_points(estela_maxima)
		motor_sfx.sonido_on()
	if event.is_action_pressed("mover_atras"):
		estela.set_max_points(0)
		motor_sfx.sonido_on()
		
##escudo
	if event.is_action_pressed("escudo") and not escudo.get_esta_activado():
		escudo.activar()
		
	#sonido de motor
	if (event.is_action_released("mover_adelante") 
		or event.is_action_released("mover_atras")):
			motor_sfx.sonido_off()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)

func _process(delta: float) -> void:
	player_input()

#Metodos Custom
func player_input() -> void:
	if not esta_input_activo():
		return
# Empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potencia_motor, 0)
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potencia_motor, 0)
# Rotacion
	dir_rotacion = 0
	if Input.is_action_pressed("rotar_antihorario"):
		dir_rotacion -= 1
	elif Input.is_action_pressed("rotar_horario"):
		dir_rotacion += 1
#Disparo
	if Input.is_action_pressed("disparo principal"):
		canion.set_esta_disparando(true)
	if Input.is_action_just_released("disparo principal"):
		canion.set_esta_disparando(false)

func esta_input_activo()-> bool:
	if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]:
		return false
	return true
	
