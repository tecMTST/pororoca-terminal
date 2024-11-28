extends Spatial
class_name ControleFaixa3D

signal iniciou_movimento(direcao, alvo)
signal terminou_movimento()
signal abaixou()
signal levantou()
signal pulou()
signal caindo()
signal no_chao()

#enums
enum modos_orientacao { x, y, z, plano_xy, plano_xz, plano_yz, todos }

#constantes
const DISTANCIA_MAXIMA = 9999.0
const DISTANCIA_MINIMA = 0.3
const DISTANCIA_PARADA = 0.1

#Variavel de ativação do componente
export var ativo = true

#modo
export(modos_orientacao) var orientacao = modos_orientacao.x

#inputs
export var controle_left = "left"
export var controle_right = "right"
export var controle_pular = "up"
export var controle_abaixar = "down"

#velocidade
export var velocidade_movimento = 10.0
export var velocidade_pulo = 7.0
export var velocidade_queda = 10.0
export var aceleracao = 2.0
export var desaceleracao = 2.0
export var aceleracao_pulo = 2.5
export var desaceleracao_pulo = 5.0
export var aceleracao_queda = 1.5
export var desaceleracao_queda = 2.5
export var altura_pulo = 3
export var tempo_abaixado = 1.0
export var abaixar_infinito = false

#Faixas
export(Array, Vector3) var faixas = []
export(int) var posicao_inicial = 0

#Captura o parent que deve ser do tipo KinematicBody
onready var parent = get_parent() as KinematicBody

#Váriaveis internas
var timerAbaixado : Timer = Timer.new()
var alvo = Vector3()
var posicao_atual = 0
var alvo_definido = false
var velocidade : Vector3 = Vector3.ZERO
var ultima_distancia = DISTANCIA_MAXIMA
var em_movimento = false
var abaixado = false
var pulando = false
var caindo = false
var base_y = 0.0;

func _ready():
	posicao_atual = posicao_inicial
	base_y = parent.global_position.y
	timerAbaixado.wait_time = tempo_abaixado
	timerAbaixado.connect("timeout", self, "levantar")
	add_child(timerAbaixado)
	_definir_alvo();

func _input(_event):
	if ativo and controle_left != "" and controle_right != "":
		if Input.is_action_just_pressed(controle_left):
			mover_esquerda()
		if Input.is_action_just_pressed(controle_right):
			mover_direita()
	if ativo and controle_pular != "":
		if Input.is_action_just_pressed("up"):
			pular()
	if ativo and controle_abaixar != "":
		if Input.is_action_just_pressed("down"):
			abaixar()
		if abaixar_infinito and Input.is_action_just_released("down"):
			levantar()

func _physics_process(delta: float) -> void:
	if ativo and faixas.size() > 0:
		_processar()
		parent.move_and_slide(velocidade, Vector3.UP)

func mover_direita():
	if not em_movimento and not pulando and not caindo:
		_destravar_posicao()
		ultima_distancia = DISTANCIA_MAXIMA
		if posicao_atual < faixas.size() - 1:
			posicao_atual = posicao_atual + 1;
			_definir_alvo()
		em_movimento = true
		emit_signal('iniciou_movimento', 'direita', alvo)

func mover_esquerda():
	if not em_movimento and not pulando and not caindo:
		_destravar_posicao()
		ultima_distancia = DISTANCIA_MAXIMA
		if posicao_atual > 0:
			posicao_atual = posicao_atual - 1;
			_definir_alvo()
		em_movimento = true
		emit_signal('iniciou_movimento', 'esquerda', alvo)

func abaixar():
	if not abaixado and not pulando and not caindo:
		abaixado = true
		if not abaixar_infinito:
			timerAbaixado.start()
		emit_signal('abaixou')

func levantar():
	if not abaixar_infinito:
		timerAbaixado.stop()
	abaixado = false
	emit_signal('levantou')

func pular():
	if abaixado:
		levantar()
	if not em_movimento and not pulando and not caindo:
		_destravar_posicao()
		alvo = Vector3(faixas[posicao_atual].x, faixas[posicao_atual].y + altura_pulo, parent.global_position.z)
		ultima_distancia = DISTANCIA_MAXIMA
		pulando = true
		alvo_definido = true
		emit_signal('pulou')

func _cair():
	if not em_movimento and pulando:
		ultima_distancia = DISTANCIA_MAXIMA
		alvo = Vector3(faixas[posicao_atual].x, faixas[posicao_atual].y, parent.global_position.z)
		alvo_definido = true
		pulando = false
		caindo = true
		emit_signal('caindo')

func _definir_alvo():
	if faixas.size() > 0:
		if orientacao == modos_orientacao.x:
			alvo = Vector3(faixas[posicao_atual].x, parent.global_position.y, parent.global_position.z)
		elif orientacao == modos_orientacao.y:
			alvo = Vector3(parent.global_position.x, faixas[posicao_atual].y, parent.global_position.z)
		elif orientacao == modos_orientacao.z:
			alvo = Vector3(parent.global_position.x, parent.global_position.y, faixas[posicao_atual].z)
		elif orientacao == modos_orientacao.plano_xy:
			alvo = Vector3(faixas[posicao_atual].x, faixas[posicao_atual].y, parent.global_position.z)
		elif orientacao == modos_orientacao.plano_xz:
			alvo = Vector3(faixas[posicao_atual].x, parent.global_position.y, faixas[posicao_atual].z)
		elif orientacao == modos_orientacao.plano_yz:
			alvo = Vector3(parent.global_position.x, faixas[posicao_atual].y, faixas[posicao_atual].z)
		else:
			alvo = faixas[posicao_atual]
		alvo_definido = true

func _processar() -> Vector3:
	if not alvo_definido:
		_definir_alvo()

	var velocidade_atual = velocidade_movimento
	var aceleracao_atual = aceleracao
	var desaceleracao_atual = desaceleracao
	if pulando:
		velocidade_atual = velocidade_pulo
		aceleracao_atual = aceleracao_pulo
		desaceleracao_atual = desaceleracao_pulo
	elif caindo:
		velocidade_atual = velocidade_queda
		aceleracao_atual = aceleracao_queda
		desaceleracao_atual = desaceleracao_queda


	var distancia = parent.position.distance_to(alvo)
	if faixas.size() > 0 and distancia > DISTANCIA_MINIMA and distancia < ultima_distancia:
		velocidade.y = move_toward(velocidade.y, (parent.position.direction_to(alvo).y * velocidade_atual), aceleracao_atual)
		velocidade.x = move_toward(velocidade.x, (parent.position.direction_to(alvo).x * velocidade_atual), aceleracao_atual)
		velocidade.z = move_toward(velocidade.z, (parent.position.direction_to(alvo).z * velocidade_atual), aceleracao_atual)
	elif faixas.size() > 0 and distancia <= DISTANCIA_MINIMA and distancia > DISTANCIA_PARADA and distancia < ultima_distancia:
		velocidade.y = move_toward(velocidade.y, 0, desaceleracao_atual)
		velocidade.x = move_toward(velocidade.x, 0, desaceleracao_atual)
		velocidade.z = move_toward(velocidade.z, 0, desaceleracao_atual)

	else:
		velocidade = Vector3.ZERO
		em_movimento = false
		if pulando and not caindo:
			_cair();
			return velocidade
		else:
			if caindo:
				emit_signal('no_chao')
			caindo = false
			emit_signal('terminou_movimento')
			_travar_posicao()
	ultima_distancia = distancia
	return velocidade

func _travar_posicao():
	if orientacao == modos_orientacao.x:
		parent.global_position.x = alvo.x
		parent.axis_lock_motion_x = true
	elif orientacao == modos_orientacao.y:
		parent.global_position.y = alvo.y
		parent.axis_lock_motion_y = true
	elif orientacao == modos_orientacao.z:
		parent.global_position.z = alvo.z
		parent.axis_lock_motion_z = true
	elif orientacao == modos_orientacao.plano_xy:
		parent.global_position.x = alvo.x
		parent.global_position.y = alvo.y
		parent.axis_lock_motion_x = true
		parent.axis_lock_motion_y = true
	elif orientacao == modos_orientacao.plano_xz:
		parent.global_position.x = alvo.x
		parent.global_position.z = alvo.z
		parent.axis_lock_motion_x = true
		parent.axis_lock_motion_z = true
	elif orientacao == modos_orientacao.plano_yz:
		parent.global_position.y = alvo.y
		parent.global_position.z = alvo.z
		parent.axis_lock_motion_y = true
		parent.axis_lock_motion_z = true
	else:
		parent.global_position.x = alvo.x
		parent.global_position.y = alvo.y
		parent.global_position.z = alvo.z
		parent.axis_lock_motion_x = true
		parent.axis_lock_motion_y = true
		parent.axis_lock_motion_z = true

func _destravar_posicao():
	if orientacao == modos_orientacao.x:
		parent.axis_lock_motion_x = false
	elif orientacao == modos_orientacao.y:
		parent.axis_lock_motion_y = false
	elif orientacao == modos_orientacao.z:
		parent.axis_lock_motion_z = false
	elif orientacao == modos_orientacao.plano_xy:
		parent.axis_lock_motion_x = false
		parent.axis_lock_motion_y = false
	elif orientacao == modos_orientacao.plano_xz:
		parent.axis_lock_motion_x = false
		parent.axis_lock_motion_z = false
	elif orientacao == modos_orientacao.plano_yz:
		parent.axis_lock_motion_y = false
		parent.axis_lock_motion_z = false
	else:
		parent.axis_lock_motion_x = false
		parent.axis_lock_motion_y = false
		parent.axis_lock_motion_z = false
