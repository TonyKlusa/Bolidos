#Meteorito.gd
class_name Meteorito
extends RigidBody2D

#Atributos export
export var vel_lineal_base: Vector2 = Vector2(300.0, 300.0)
export var vel_ang_base:float = 3.0
export var hitpoints_base: float = 10.0

#Atribs
var hitpoints:float

## Variables onready
onready var impacto_sfx = $impacto_sfx
onready var Impacto_fx = $Impacto_fx

# Metodos

#func _ready() -> void:
#	pass 
#	#linear_velocity = vel_lineal_base #Saco para hacerlo funcional
#	#angular_velocity = vel_ang_base
#Metodo Custom
func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	if hitpoints <= 0 :
		destruir()
	impacto_sfx.play()
	Impacto_fx.play("impacto")
	
func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
func factor_velocidad_aleatoria()-> float:
	randomize()
	return rand_range(1.1, 1.4)
	
#Constructor
func crear(pos:Vector2, dir:Vector2, tamanio:float) -> void:
	position = pos
	#calcular masa y tamaños de sprite y colisionador
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	var radio:int = int($Sprite.texture.get_size().x /2 * tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	#Calcular velocidades
	linear_velocity = (vel_lineal_base * dir / tamanio) * factor_velocidad_aleatoria()
	angular_velocity = (vel_ang_base / tamanio) * factor_velocidad_aleatoria()
	# calcular hitpoints
	hitpoints = hitpoints_base * tamanio
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
