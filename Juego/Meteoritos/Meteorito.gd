#Meteorito.gd
class_name Meteorito
extends RigidBody2D

#Atributos export
export var vel_lineal_base: Vector2 = Vector2(300.0, 300.0)
export var vel_ang_base:float = 3.0
export var hitpoints_base: float = 10.0

#func _ready() -> void:
#	angular_velocity = vel_ang_base
	
#Atribs
var hitpoints:float
#Crear var para saber si esta dentro del sector de meteoritos
var esta_en_sector: bool = true setget set_esta_en_sector
var pos_spawn_original: Vector2
var vel_spawn_original: Vector2
var esta_destruido:bool = false

## Variables onready
onready var impacto_sfx = $impacto_sfx
onready var Impacto_fx = $Impacto_fx

# Setters y getters
func set_esta_en_sector(valor:bool) ->void:
	esta_en_sector = valor

func _ready() -> void:
	Eventos.emit_signal("minimapa_objeto_creado")
#func _ready() -> void:
#	pass 
#	#linear_velocity = vel_lineal_base #Saco para hacerlo funcional
#	#angular_velocity = vel_ang_base
#Metodo Custom
func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	if hitpoints <= 0 and not esta_destruido:
		esta_destruido = true
		destruir()
	impacto_sfx.play()
	Impacto_fx.play("impacto")
	
func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("meteorito_destruido",global_position)
	queue_free()
	
func factor_velocidad_aleatoria()-> float:
	randomize()
	return rand_range(1.1, 1.4)
	
#Constructor
func crear(pos:Vector2, dir:Vector2, tamanio:float) -> void:
	position = pos
	pos_spawn_original = pos
	#calcular masa y tamaños de sprite y colisionador
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	var radio:int = int($Sprite.texture.get_size().x /2 * tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	#Calcular velocidades
	linear_velocity = (vel_lineal_base * dir / tamanio) * factor_velocidad_aleatoria()
	vel_spawn_original = linear_velocity
	angular_velocity = (vel_ang_base / tamanio) * factor_velocidad_aleatoria()
	# calcular hitpoints
	hitpoints = hitpoints_base * tamanio
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if esta_en_sector:
		return
	
	var mi_transform :=state.get_transform()
	mi_transform.origin = pos_spawn_original
	linear_velocity = vel_spawn_original
	state.set_transform(mi_transform)
	esta_en_sector = true
	
