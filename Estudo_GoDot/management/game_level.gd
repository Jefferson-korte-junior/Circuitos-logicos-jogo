# Este script estende a classe Node2D, que é um nó usado para criar elementos e lógicas em 2D.
extends Node2D

@onready var player: CharacterBody2D = get_node("Mask Dude")
@onready var interface: CanvasLayer = get_node("Interface")
# Declara uma variável exportada chamada `scene_path`. Isso permite que seu valor seja definido diretamente no editor do Godot.
# Inicialmente, a variável é uma string vazia.
@export var scene_path: String = ""

# Função especial `_ready`, que é chamada automaticamente quando o nó está pronto (após ser carregado na cena).
func _ready() -> void:
	interface.update_health(player.max_health)
	# Define a propriedade `target_path` do nó `transition_screen` com o valor da variável `scene_path`.
	transition_screen.target_path = scene_path

	# Conecta o sinal "start_level" do `transition_screen` a uma função chamada `start_level` neste script.
	# Isso significa que, quando o sinal "start_level" for emitido, ele chamará a função `start_level`.
	transition_screen.connect(
		"start_level", Callable(self, "start_level")
	)
	if transition_screen.current_score != 0:
		player.total_score = transition_screen.current_score
		interface.update_score(transition_screen.current_score)
		
	if transition_screen.current_health != 0:
		player.health = transition_screen.current_health
		interface.update_health(transition_screen.current_health)

# Função chamada `start_level`, que será acionada quando o sinal "start_level" for emitido.
func start_level() -> void:
	# Imprime a mensagem "Aqui" no console, indicando que a função foi executada corretamente.
	print("Aqui")
