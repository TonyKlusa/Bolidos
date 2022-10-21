#Meteorito.gd
class_name Meteorito
extends RigidBody2D

#Atributos export
export var vel_lineal_base: Vector2 = Vector2(300.0, 300.0)
export var vel_ang_base:float = 3.0
# Metodos

func _ready() -> void:
	#linear_velocity = vel_lineal_base #Saco para hacerlo funcional
	angular_velocity = vel_ang_base
	
#Constructor
func crear(pos:Vector2, dir:Vector2) - void:
	position = pos
	linear_velocity = vel_lineal_base * dir
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
