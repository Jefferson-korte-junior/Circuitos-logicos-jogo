# Este script estende a classe Area2D, que é usada para definir áreas que podem detectar colisões ou interações em um espaço 2D.
extends Area2D
# Declara uma variável `sprite`, que referencia o nó filho chamado "Texture".
# Esse nó provavelmente é do tipo Sprite2D e será usado para exibir uma imagem.
@onready var sprite: Sprite2D = get_node("Texture")

@export var collect_effect: PackedScene = null

# Declara uma lista (array) que contém caminhos para várias imagens de frutas.
# Essas imagens são armazenadas em um diretório específico dentro do projeto.
var fruits_list: Array = [
	"res://assets/Items/Fruits/Apple.png",       # Caminho para a imagem da maçã.
	"res://assets/Items/Fruits/bananas.png",     # Caminho para a imagem da banana.
	"res://assets/Items/Fruits/Cherries.png",    # Caminho para a imagem das cerejas.
	"res://assets/Items/Fruits/Collected.png",   # Caminho para uma fruta coletada.
	"res://assets/Items/Fruits/Kiwi.png",        # Caminho para a imagem do kiwi.
	"res://assets/Items/Fruits/Melon.png",       # Caminho para a imagem do melão.
	"res://assets/Items/Fruits/Orange.png",      # Caminho para a imagem da laranja.
	"res://assets/Items/Fruits/Pineapple.png"    # Caminho para a imagem do abacaxi.
]

var scores_list: Array = [
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8
]

var score: int = 0 

func _ready() -> void:
	# Garante que a geração de números aleatórios seja única a cada execução.
	randomize()
	var random_number:int 

	# Define a textura do sprite com uma imagem aleatória da lista `fruits_list`.
	sprite.texture = load(
		fruits_list[randi() % fruits_list.size()]
	)

	# Gera um número aleatório baseado no tamanho da lista `scores_list`.
	score = scores_list[randi() % scores_list.size()]


func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mask_dude"):
		body.update_score(score)
		body.update_health(Vector2.ZERO, randi() % 3 + 1, "increase")
		spawn_effect()
		queue_free()
	

func spawn_effect() -> void:
	var effect = collect_effect.instantiate()
	effect.global_position = global_position
	get_tree().root.call_deferred("add_child", effect)
	 
	
