##ReledeMasa.gd
extends Node2D

## Señal interna
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		$AnimationPlayer.play("activado")
func _on_DetectorPlayer_body_entered(body: Node) -> void:
	$DetectorPlayer/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("super_activado")
	body.desactivar_controles()
	atraer_player(body)

## Metodos personalizados
func atraer_player(body: Node) -> void:
	$Tween.interpolate_property(body, "global_position", body.global_position, global_position, 1.0,
								Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_all_completed() -> void:
	print("geniex")
