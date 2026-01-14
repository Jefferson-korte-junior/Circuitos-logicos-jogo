# Este script estende a classe Area2D, que é usada para criar áreas que podem detectar colisões ou interações em 2D.
extends Area2D

# Declara uma variável exportada chamada `scene_path`. Ela pode ser configurada diretamente no editor do Godot
# e armazenará o caminho para uma cena (provavelmente usada em transições).
@export var scene_path: String =  ""

# Função que é chamada automaticamente quando um corpo entra na área associada a este nó Area2D.
func _on_body_entered(body: Node2D) -> void:
	# Verifica se o corpo que entrou pertence ao grupo "mask_dude".
	# Grupos são usados para categorizar nós e facilitar a verificação.
	if body.is_in_group("mask_dude"):
		# Define o destino da transição de cena para o valor armazenado em `scene_file_path`.
		# Nota: Certifique-se de que `scene_file_path` está corretamente definido em outro lugar no script,
		# ou ele causará um erro por não existir no escopo atual.
		transition_screen.target_path = scene_file_path

		# Desativa o processamento de física do corpo que entrou na área.
		# Isso impede que ele execute qualquer lógica física, como movimento ou colisões.
		body.set_physics_process(false)

		# Executa uma ação de animação chamada "dead" no sprite do corpo que entrou.
		# Certifique-se de que o nó `sprite` associado ao corpo possui o método `action_behavior` implementado
		# e que a animação "dead" existe.
		body.sprite.action_behavior("dead")
