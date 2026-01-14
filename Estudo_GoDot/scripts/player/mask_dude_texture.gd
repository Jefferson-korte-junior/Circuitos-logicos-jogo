extends Sprite2D
# Este script estende a classe Sprite2D, usada para manipular imagens/texturas na cena.
# Ele está configurado para controlar a animação de um sprite com base no movimento horizontal.

var on_action: bool = false

@export var dust_particles: GPUParticles2D = null

@export var animation: AnimationPlayer = null
# Declara uma variável exportada chamada `animation`, do tipo AnimationPlayer.
# `AnimationPlayer` é usado para reproduzir animações definidas no editor Godot.
# A anotação `@export` permite configurar essa variável no editor, vinculando-a ao nó AnimationPlayer da cena.

@export var mask_dude: CharacterBody2D = null

func animate(velocity: Vector2) -> void:
	# Função principal para controlar as animações do sprite com base na velocidade fornecida.
	# Ela divide a lógica em duas etapas:
	# 1. Ajustar a orientação do sprite com base na direção horizontal (velocity.x).
	# 2. Decidir qual animação reproduzir com base na direção do movimento.
	
	if on_action:
		dust_particles.emitting = false
		return
	
	if velocity.y != 0:
		dust_particles.emitting = false
		vertical_move_behavior(velocity.y)
		return
		
	horizontal_move_behavior(velocity.x)
	# Chama a função que define qual animação reproduzir (ex.: "run" ou "idle").

	change_orientation_based_on_direction(velocity.x)
	# Chama a função que ajusta a orientação horizontal (esquerda/direita) do sprite.

   
func action_behavior (action: String) -> void:
	on_action =  true
	animation.play(action)
	
	
func change_orientation_based_on_direction(direction: float) -> void:
	# Função para alterar a orientação do sprite horizontalmente (virado para a esquerda ou para a direita).
	
	if direction > 0:
		flip_h = false
		# Se a direção for positiva (movimento para a direita), o sprite não será espelhado horizontalmente.

	if direction < 0:
		flip_h = true
		# Se a direção for negativa (movimento para a esquerda), o sprite será espelhado horizontalmente.
		
		
		
func vertical_move_behavior(direction: float) -> void:
	if direction > 0:
		animation.play("fall")
	
	
	if direction < 0:
		animation.play("jump")
		
		
func horizontal_move_behavior(direction: float) -> void:
	# Função para determinar a animação com base na direção horizontal.
	
	if direction != 0:
		# Se houver movimento horizontal (direction diferente de 0):
		animation.play("run")
		# Toca a animação "run", que representa o personagem correndo.
		dust_particles.emitting = true
		return
		# Finaliza a execução da função, já que a animação "run" foi definida.

	animation.play("idle")
	# Se não houver movimento (direction igual a 0), toca a animação "idle", que representa o personagem parado.
	dust_particles.emitting = false

# Função que é executada automaticamente quando uma animação termina.
# Ela recebe o nome da animação finalizada como parâmetro (`anim_name`).
func _on_animation_animation_finished(anim_name: StringName) -> void:
	# Define que nenhuma ação está sendo realizada no momento.
	on_action = false
	# Verifica se a animação que acabou foi chamada de "hit".
	if anim_name == "hit":
		# Se for a animação "hit", define que o estado de knockback do personagem `mask_dude` está desativado.
		mask_dude.on_knockback = false
	
	if anim_name == "dead":
		hide()
		transition_screen.fade_in()
	
		


 
