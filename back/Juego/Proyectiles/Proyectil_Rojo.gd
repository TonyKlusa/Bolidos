class_name Proyectil 

extends Area2D

## Atributos
var Velocidad:Vector2 = Vector2.ZERO
var danio:float

## Metodos 
func crear(pos:Vector2,dir:float,vel:float,danio_p:int) ->void:
	position = pos 
	rotation = rot 
	velocidad = Vector2(vel,0).rotated(dir)
	
	
func _physics_process(Delta:float) -> void:
	position += velocidad * delta 
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

