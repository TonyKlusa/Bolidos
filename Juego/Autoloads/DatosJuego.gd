##DatosJuego.gd

extends Node

## Atributos
var player_actual: Player = null setget set_player_actual, get_player_actual

## Setters and Getters
func set_player_actual(player: Player) -> void:
	player_actual = player
	
func get_player_actual() -> Player:
	return player_actual
	
