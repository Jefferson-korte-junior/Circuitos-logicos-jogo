# Este script estende a classe CanvasLayer, que é usada para criar elementos gráficos 2D
# fixados na tela, como HUDs (Heads-Up Display) ou camadas de interface de usuário.
extends CanvasLayer

signal start_level

# Declaração de uma variável que referencia o nó AnimationPlayer no caminho especificado.
# O nó AnimationPlayer será acessado após a cena estar carregada.
@onready var animation: AnimationPlayer = get_node("Background/Animation")

# Declara uma variável de string que armazenará o caminho para uma cena alvo.
var target_path: String

var current_score: int = 0
var current_health: int = 0

# Função responsável por executar uma transição de fade-in e armazenar o caminho da cena.
func fade_in() -> void:
	# Inicia a reprodução da animação chamada "fade_in" no AnimationPlayer.
	animation.play("fade_in")


func on_animation_fineshed(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		var _change_scene: bool =  get_tree().change_scene_to_file(target_path)
		animation.play("fade_out")
	
	if anim_name == "fade_out":
		var _start: bool = emit_signal("start_level")
	

func reset() -> void:
	current_health = 0
	current_score = 0
