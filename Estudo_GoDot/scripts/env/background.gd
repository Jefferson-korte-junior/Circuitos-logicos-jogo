extends ParallaxBackground
# Este script estende a classe ParallaxBackground, que é usada para criar fundos com efeito de paralaxe.
# Paralaxe é um efeito visual onde camadas de fundo se movem em diferentes velocidades, criando profundidade.

@onready var parallax_layer: ParallaxLayer = get_node("ParallaxLayer")
@onready var background_layer: TextureRect = get_node("ParallaxLayer/BackgroundLayer")
# Declara uma variável `background_layer` do tipo TextureRect que será inicializada após a cena estar completamente carregada.
# O método `get_node("ParallaxLayer/BackgroundLayer")` busca e retorna o nó chamado "BackgroundLayer" dentro de "ParallaxLayer".
# Isso permite manipular a camada de fundo diretamente pelo script.

var background_images_list: Array = [
	"res://assets/Background/Blue.png",
	"res://assets/Background/Brown.png",
	"res://assets/Background/Gray.png",
	"res://assets/Background/Green.png",
	"res://assets/Background/Pink.png",
	"res://assets/Background/Purple.png",
	"res://assets/Background/Yellow.png"
]
# Define uma lista (Array) contendo os caminhos das imagens de fundo.
# Cada item na lista é o caminho para um arquivo de imagem no projeto Godot.
# Essas imagens serão usadas como fundos no jogo, permitindo alternar entre elas dinamicamente.

@export var direction: Vector2
@export var move_speed: float

func _ready() -> void:
	# A função `_ready()` é chamada automaticamente quando a cena é carregada e pronta para ser exibida.
	background_layer.texture = load(
		background_images_list[
			randi() % background_images_list.size()
		]
	)
	# Altera a textura do fundo (`background_layer.texture`) para uma imagem escolhida aleatoriamente da lista `background_images_list`.
	# `randi()` gera um número inteiro aleatório.
	# `randi() % background_images_list.size()` limita o valor aleatório ao tamanho da lista, garantindo que o índice gerado seja válido.
	# `load()` carrega a textura a partir do caminho especificado.
	

# Função chamada a cada quadro para atualizar a física.
func _physics_process(delta: float) -> void:
	 # Move o fundo (parallax layer) baseado na direção, velocidade e no tempo.
	parallax_layer.motion_offset += direction * delta * move_speed
	
