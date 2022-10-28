#CamaraNivel.gd
extends Camera2D

## Variable Export
export var variacion_zoom: float = 0.1
export var zoom_maximo: float = 1.5
export var zoom_minimo: float = 0.8

#Atributos
var zoom_original: Vector2
var puede_hacer_zoom:bool = true setget set_puede_hacer_zoom

#Atributos onready
onready var tween_zoom: Tween = $TweenZoom

func _ready() -> void:
	zoom_original = zoom

#Met custom para devolcer zoom original
func devolver_zoom_original()->void:
	puede_hacer_zoom = false
	zoom_suavizado(zoom_original.x, zoom_original.y,1.0)


## Metodos
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_acercar"):
		controlar_zoom(-variacion_zoom)
	elif event.is_action_pressed("zoom_alejar"):
		controlar_zoom(variacion_zoom)
		
	## Metodos personalizados
func controlar_zoom(mod_zoom: float) -> void:
	zoom.x = clamp(zoom.x + mod_zoom, zoom_minimo, zoom_maximo)
	zoom.y = clamp(zoom.y + mod_zoom, zoom_minimo, zoom_maximo)
	zoom_suavizado(zoom.x, zoom.y, 0.15)

func zoom_suavizado(nuevo_zoom_x:float, nuevo_zoom_y:float, tiempo_transicion:float)-> void:
	tween_zoom.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(nuevo_zoom_x, nuevo_zoom_y),
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween_zoom.start()
	
#Setters y getters
func set_puede_hacer_zoom(puede:bool)-> void:
	puede_hacer_zoom = puede

	
	
