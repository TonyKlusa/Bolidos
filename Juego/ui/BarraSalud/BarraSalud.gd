##BarraSalud
class_name BarraSalud
extends ProgressBar

## Atributos export
export var es_top_level: bool = false

## Atributo onready
onready var tween_visibilidad: Tween = $TweenVisibilidad

## Metodos
func _ready() -> void:
	modulate = Color(1,1,1, es_top_level)
	set_as_toplevel(es_top_level)
	if es_top_level:
		rect_global_position = owner.global_position + rect_position

## Metodos personalizados
func set_valores(hitpoints: float) -> void:
	max_value = hitpoints
	value = hitpoints

func set_hitpoints_actual(hitpoints: float) -> void:
	value = hitpoints

func controlar_barra(hitpoints_nave: float, mostrar: bool) -> void:
	value = hitpoints_nave
	
	if not tween_visibilidad.is_active() and modulate.a != int(mostrar):
		tween_visibilidad.interpolate_property(self, "modulate", Color(1,1,1, not mostrar),
			Color(1,1,1,mostrar), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
		tween_visibilidad.start()


## Señales internas
func _on_TweenVisibilidad_tween_all_completed():
	if modulate.a == 1.0:
		controlar_barra(value, false)
