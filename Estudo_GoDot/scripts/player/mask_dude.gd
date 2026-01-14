extends CharacterBody2D
# Este script estende a classe CharacterBody2D, usada para objetos controlados pelo jogador ou NPCs com física integrada.
# Ele gerencia movimentos, salto e animações do personagem.

@onready var sprite: Sprite2D = get_node("Texture")
# Declara a variável `sprite`, que será inicializada quando a cena estiver carregada e pronta.
# A anotação `@onready` garante que o nó chamado "Texture" seja acessado na árvore de nós da cena.
# Este nó precisa ser do tipo Sprite2D para manipular a aparência e animações visuais do personagem.

@onready var stomp_area_collision: CollisionShape2D = get_node("StompArea/Collision")

var total_score: int = 0

var jump_count: int = 0 
# Variável para controlar a quantidade de pulos executados pelo personagem.
# Geralmente usada para implementar mecânicas de salto duplo ou múltiplo.

var is_on_double_jump: bool = false

var is_dead: bool = false

var on_knockback: bool = false

var knockback_direction: Vector2

var max_health: float = 0.0

@export var health: float = 10.0

@export var move_speed: float = 100.0
# Determina a velocidade horizontal do personagem. É configurável diretamente no editor Godot.

@export var jump_speed: float = -256.0
# Velocidade aplicada ao eixo Y durante o salto. Configurável no editor Godot.

@export var gravity_speed: float = 512.0
# Velocidade de queda (gravidade) aplicada ao eixo Y do personagem. Configurável no editor Godot.

@export var damage: int = 5

func _ready() -> void:
	max_health = health
	

func _physics_process(delta: float) -> void:
	# Função que é chamada automaticamente em cada frame de atualização física.
	# `delta` representa o tempo decorrido desde o último frame, útil para cálculos independentes da taxa de quadros.
	if is_dead:
		return
		
	if on_knockback:
		knockback_move()
		return

	move()
	# Chama a função `move` para calcular e atualizar a velocidade horizontal do personagem.

	velocity.y += delta * gravity_speed
	# Aplica gravidade ao eixo Y do personagem, fazendo com que ele caia constantemente.

	var _move := move_and_slide()
	# Chama o método `move_and_slide()` para aplicar as velocidades calculadas e gerenciar colisões físicas.
	# `_move` pode armazenar informações sobre colisões durante o movimento, mas não está sendo usado aqui.

	jump()
	# Chama a função `jump` para gerenciar os pulos do personagem.

	sprite.animate(velocity)
	# Chama a função `animate()` no nó `sprite`, provavelmente para ajustar a animação com base na velocidade.
	# Certifique-se de que o método `animate()` esteja implementado no script associado ao Sprite2D, pois ele não é nativo.


# Função responsável por aplicar um efeito de empurrão ou repulsão ao personagem.
func knockback_move() -> void:
	# Define a velocidade do personagem baseada na direção do knockback,
	# multiplicada pela velocidade de movimento e ampliada por um fator de 2.
	velocity = knockback_direction * move_speed * 2
	# Move o personagem com base na velocidade calculada e gerencia colisões físicas.
	# O método move_and_slide é usado para aplicar a movimentação suavemente enquanto lida com colisões.
	var _move := move_and_slide()
	# Atualiza a animação do sprite do personagem com base na velocidade atual.
	# A função animate() precisa estar implementada no nó Sprite2D.
	sprite.animate(velocity)


func move() -> void:
	# Função que calcula o movimento horizontal do personagem com base na entrada do jogador.

	var direction: float = get_direction()
	# Obtém a direção horizontal (esquerda ou direita) do jogador através da função `get_direction`.

	velocity.x = direction * move_speed
	# Atualiza a velocidade no eixo X do personagem, multiplicando a direção pela velocidade definida.

func get_direction() -> float:
	# Função que calcula e retorna a direção horizontal do movimento com base na entrada do jogador.
	
	return (
		Input.get_axis("walk_left", "walk_right")
		# `Input.get_axis` verifica as ações de entrada mapeadas como "ui_left" e "ui_right".
		# Retorna -1 se "ui_left" estiver pressionado, 1 se "ui_right" estiver pressionado e 0 se nenhuma estiver.
	)

func jump() -> void:
	# Função que gerencia a mecânica de salto.
	if is_on_floor():
		jump_count = 0
		is_on_double_jump = false
		stomp_area_collision.set_deferred("disabled", false)

	if Input.is_action_just_pressed("jump") and jump_count < 2:
		# Verifica se a ação de salto ("ui_select") foi pressionada e se o jogador pode realizar mais um salto (máximo de 2).
		stomp_area_collision.set_deferred("disabled", false)
		velocity.y = jump_speed
		# Aplica a velocidade de salto ao eixo Y para fazer o personagem pular.
		
		jump_count += 1
	
	if jump_count == 2 and not is_on_double_jump:
		sprite.action_behavior("double_jump")
		is_on_double_jump = true
		
# Função responsável por atualizar a vida (health) do personagem.
# Pode reduzir ou aumentar a vida com base no tipo especificado, além de aplicar efeitos como knockback ou morte.
func update_health(target_position: Vector2, value: int, type: String) -> void:
	 # Se o personagem estiver morto (is_dead == true), a função termina imediatamente sem realizar ações.
	if is_dead:
		return
	# Se o tipo for "decrease" (redução de vida, como ao tomar dano):
	if type == "decrease":
		# Calcula a direção do knockback com base na posição global do personagem e a posição do alvo que causou o dano.
		knockback_direction = (global_position - target_position).normalized()
		# Ativa a animação de "hit" no sprite do personagem, indicando que ele foi atingido.
		sprite.action_behavior("hit")
		 # Define que o estado de knockback está ativo, para aplicar o efeito de repulsão.
		on_knockback = true
		
		# Atualiza a saúde do personagem, reduzindo-a pelo valor especificado (value).
		# O método clamp garante que a saúde não caia abaixo de 0 e não ultrapasse o valor máximo permitido (max_health).
		health = clamp(health - value, 0, max_health)
		# Verifica se a saúde do personagem chegou a 0, indicando que ele está morto:
		transition_screen.current_health = health
		get_tree().call_group("interface", "update_health", health)

		if health == 0:
			is_dead = true
			transition_screen.reset()
			sprite.action_behavior("dead")
			
		return
	
	# Se o tipo for "increase" (aumento de vida, como ao receber cura):
	if type == "increase":
		# Atualiza a saúde do personagem, aumentando-a pelo valor especificado.
		# Novamente, o método clamp garante que a saúde fique entre 0 e max_health.
		health = clamp(health + value, 0, max_health)
		transition_screen.current_health = health
		get_tree().call_group("interface", "update_health", health)

func  on_stomp_area_entered(_area: Area2D) -> void:
	#if area.is_in_group("hazard"):
	#	pass # Replace with function body.
	pass


func on_stomp_body_entered(body: Node2D) -> void:
	if body.is_in_group("hazard"):
		body.update_health(damage)
		
		knockback_direction = (global_position - body.global_position).normalized()
		sprite.action_behavior("hit")
		on_knockback = true
		
func update_score(score: int) -> void:
	total_score += score
	transition_screen.current_score = total_score
	get_tree().call_group("interface", "update_score", total_score)
	
		
	
