#Eventos.gd

extends Node

signal disparo(proyectil)
signal nave_destruida(nave,posicion, explosiones)
signal spawn_meteorito(posicion, direccion, tamanio)
signal meteorito_destruido(posicion)
signal nave_en_sector_peligro(centro_camara, tipo_peligro, num_peligros)
signal base_destruida(base,posiciones)
signal spawn_orbital(orbital)
# HUD
signal nivel_iniciado()
signal nivel_terminado()
signal detecto_zona_recarga(entrando)
signal cambio_numero_meteoritos(numero)
signal actualizar_tiempo(tiempo_restante)
signal cambio_energia_laser(energia_max, energia_actual)
signal ocultar_energia_laser()
