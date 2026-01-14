# Este script está sendo anexado a um nó do tipo StaticBody2D, que é um corpo estático no Godot.
extends StaticBody2D

@onready var state_timer: Timer = get_node("StateTimer")
@onready var animation: AnimationPlayer = get_node("Animation")

var max_health: int = 0

# Declaração de uma variável chamada "current_state" que guarda o estado atual (pode ser "on" ou "off").
# O estado inicial é definido como "off".
var current_state: String = "off"
var is_invincible: bool = false

@export var damage: int 
@export var health: int = 15

func _ready() -> void:
	max_health = health

# Função que é chamada quando o temporizador de estado (state_timer) dispara seu sinal "timeout".
func on_state_timer_timeout() -> void:
	state_timer.start()
	
	# Verifica se o estado atual é "off".
	if current_state == "off":
		# Altera o estado para "on".
		current_state = "on"
		is_invincible = true
		animation.play(current_state)
		# Encerra a execução da função.
		return
		
	# Verifica se o estado atual é "on".
	if current_state == "on":
		# Altera o estado para "off".
		current_state = "off"
		is_invincible = false
		animation.play(current_state)
		# Encerra a execução da função.
		return


#Função para quando um corpo entrar dentro da ara de detecção, que sera o fogo
func on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("mask_dude"): #Se o corpo que estive dentro for o mask_dude (nosso personagem)
		body.update_health(global_position, damage, "decrease") 

func update_health(value: int) -> void:
	if is_invincible:
		return
		
	health = clamp(health - value, 0, max_health)
	
	if health == 0:
		state_timer.stop()
		current_state = "off"
		animation.play(current_state)
		
		return
		
	animation.play("hit")


func on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		animation.play(current_state)
	
