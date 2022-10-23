#Eventos.gd

extends Node

signal disparo(proyectil)
signal nave_destruida(posicion, explosiones)
signal spawn_meteorito(posicion, direccion, tamanio)
signal meteorito_destruido(posicion)

