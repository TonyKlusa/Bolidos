#Nivel.gd
class_name Nivel
extends Node2D

## Atributos Onready
onready var contenedor_proyectiles:Node 
onready var contenedor_meteoritos: Node
onready var contenedor_sector_meteoritos: Node
onready var camara_nivel: Camera2D = $CamaraNivel
onready var contenedor_enemigos: Node

#Atributos export
export var explosion: PackedScene = null
export var meteorito: PackedScene = null
export var explosion_meteorito: PackedScene = null
export var sector_meteoritos : PackedScene = null
export var tiempo_transicion_camara: float = 0.8
export var enemigo_interceptor: PackedScene = null


#Atributos
var meteoritos_totales:int = 0
var player: Player = null

## Metodos

func _ready() -> void:
	conectar_seniales()
	crear_contenedores()
	player = DatosJuego.get_player_actual()

	
## Metodos Custom
func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	Eventos.connect("spawn_meteorito", self,"_on_spawn_meteoritos")
	Eventos.connect("meteorito_destruido", self,"_on_meteorito_destruido")
	Eventos.connect("nave_en_sector_peligro", self, "_on_nave_en_sector_peligro")
	Eventos.connect("base_destruida",self,"_on_base_destruida")
	Eventos.connect("spawn_orbital",self,"_on_spawn_orbital")
	
	
func crear_contenedores():
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	#Crear contenedores para meteoritos
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "ContenedorMeteoritos"
	add_child(contenedor_meteoritos)
	contenedor_sector_meteoritos = Node.new()
	contenedor_sector_meteoritos.name = "ContenedorSectorMeteoritos"
	add_child(contenedor_sector_meteoritos)
	#Creamos un contenedor de enemigos
	contenedor_enemigos = Node.new()
	contenedor_enemigos.name = "ContenedorEnemigos"
	add_child(contenedor_enemigos)
	
	
	
func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)
	##add_child(proyectil)

func _on_nave_destruida(nave: Player, posicion: Vector2, num_explosiones: int) -> void:
	if nave is Player:
		transicion_camaras(posicion, posicion + crear_posicion_aleatoria(-200.0, 200.0),
		camara_nivel, tiempo_transicion_camara)
	
	for i in range(num_explosiones):
		var new_explosion: Node2D = explosion.instance()
		new_explosion.global_position = posicion + crear_posicion_aleatoria(100.0,50.0)
		add_child(new_explosion)
		yield(get_tree().create_timer(0.6), "timeout")

func crear_explosion(posicion: Vector2,tamanio: float = 1.0, numero: int = 1, intervalo: float = 0.0, 
					rangos_aleatorios: Vector2 = Vector2(0.0, 0.0)) -> void:
	for _i in range(numero):
		var new_explosion: Node2D = explosion.instance()
		new_explosion.global_position = posicion + crear_posicion_aleatoria(rangos_aleatorios.x, rangos_aleatorios.y)
		#Agrego explosiones de diferentes tamaños
		new_explosion.scale *= tamanio
		add_child(new_explosion)
		yield(get_tree().create_timer(intervalo),"timeout")
		
func _on_base_destruida(_base, pos_partes: Array) -> void:
	for posicion in pos_partes:
		crear_explosion(posicion)
		yield(get_tree().create_timer(0.5),"timeout")
		
func _on_spawn_meteoritos(pos_spawn: Vector2, dir_meteorito: Vector2, tamanio:float) -> void:
	var new_meteorito:Meteorito = meteorito.instance()
	new_meteorito.crear(
		pos_spawn,
		dir_meteorito,
		tamanio
	)
	contenedor_meteoritos.add_child(new_meteorito)

func _on_meteorito_destruido(pos: Vector2) ->void:
	var new_explosion: ExplosionMeteorito = explosion_meteorito.instance()
	new_explosion.global_position = pos
	add_child(new_explosion)
#	yield(get_tree().create_timer(0.6), "timeout")
	controlar_meteoritos_restantes()
	

	
	#Metodo de deteccion de Nave / Peligro
func _on_nave_en_sector_peligro(centro_cam: Vector2, tipo_peligro: String, num_peligros: int) ->void:
	if tipo_peligro == "Meteorito":
		crear_sector_meteoritos(centro_cam, num_peligros)
	elif tipo_peligro == "Enemigo":
		crear_sector_enemigos(num_peligros)
			

func crear_sector_enemigos(num_enemigos: int) -> void:
	for _i in range(num_enemigos):
		var new_interceptor: EnemigoInterceptor = enemigo_interceptor.instance()
		var spawn_pos: Vector2 = crear_posicion_aleatoria(1000.0, 800.0)
		new_interceptor.global_position = player.global_position + spawn_pos
		contenedor_enemigos.add_child(new_interceptor)

func crear_sector_meteoritos(centro_cam: Vector2, num_peligros: int) -> void:
	meteoritos_totales = num_peligros
	var new_sector_meteoritos: SectorMeteoritos = sector_meteoritos.instance()
	new_sector_meteoritos.crear(centro_cam, num_peligros)
	camara_nivel.global_position = centro_cam
	#camara_nivel.current = true #lo quito
	contenedor_sector_meteoritos.add_child(new_sector_meteoritos)
	camara_nivel.zoom = $Player/CamaraPlayer.zoom
	camara_nivel.devolver_zoom_original()
	transicion_camaras(
		$Player/CamaraPlayer.global_position,
		camara_nivel.global_position,
		camara_nivel,
		tiempo_transicion_camara*0.10)
## 
func crear_posicion_aleatoria(rango_horizontal: float, rango_vertical: float) -> Vector2:
	randomize()
	var rand_x = rand_range(-rango_horizontal, rango_horizontal)
	var rand_y = rand_range(-rango_vertical, rango_vertical)
	
	return Vector2(rand_x, rand_y)

func transicion_camaras(desde: Vector2, hasta:Vector2, camara_actual: Camera2D, tiempo_transicion:float) ->void:
	$TweenCamara.interpolate_property(
		camara_actual,
		"global_position",
		desde,
		hasta,
		tiempo_transicion_camara,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT)
	camara_actual.current = true
	$TweenCamara.start()
		 
#Funcion para controlar meteoritos

func controlar_meteoritos_restantes() -> void:
	meteoritos_totales -=1
	#print(meteoritos_totales)
	if meteoritos_totales == 0:
		contenedor_sector_meteoritos.get_child(0).queue_free()
		$Player/CamaraPlayer.set_puede_hacer_zoom(true)
		
		var zoom_actual = $Player/CamaraPlayer.zoom
		$Player/CamaraPlayer.zoom = camara_nivel.zoom
		$Player/CamaraPlayer.zoom_suavizado(zoom_actual.x, zoom_actual.y,1.0)
		transicion_camaras(
			camara_nivel.global_position,
			$Player/CamaraPlayer.global_position,
			$Player/CamaraPlayer,
			tiempo_transicion_camara*0.10)

#Señales internas

func _on_TweenCamara_tween_completed(object: Object, key: NodePath) -> void:
	if object.name == "CamaraPlayer":
		object.global_position = $Player.global_position


func _on_spawn_orbital(enemigo: EnemigoOrbital) -> void:
	contenedor_enemigos.add_child(enemigo)
