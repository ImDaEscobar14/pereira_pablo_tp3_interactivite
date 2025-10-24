extends CharacterBody2D

@export var speed = 60.0
@export var game_over_distance = 16.0
var game_over_triggered = false
var restart_connected = false 

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_over_ui = get_tree().current_scene.get_node("game_over_ui") 
@onready var game_over_label = game_over_ui.get_node("game_over_label")
@onready var restart_button = game_over_ui.get_node("bouton_recommencer")
var directionName = "bas"

func _physics_process(_delta):
	if Player.instance == null:
		return
	var player = Player.instance

	# pour le player
	var direction = player.global_position - global_position

	# pour que le player ne bouge plus
	if game_over_triggered:
		player.set_physics_process(false)  
		player.velocity = Vector2.ZERO
		player.animation.play("animation_idle")
		
	else:
		# mouvement du monster
		if direction.length() > 0.1:
			velocity = direction.normalized() * speed
			move_and_slide()

			# direction de l'animattion
			if abs(direction.x) > abs(direction.y):
				directionName = "droite" if direction.x > 0 else "gauche"
			else:
				directionName = "bas" if direction.y > 0 else "haut"

			animation.play(directionName)
		else:
			velocity = Vector2.ZERO
			animation.play("idle")

		# dependant de la distance pour le game over
		if not game_over_triggered and global_position.distance_to(player.global_position) <= game_over_distance:
			game_over_triggered = true
			print("Game Over !")

			# bloque le joueur
			player.set_physics_process(false)
			player.velocity = Vector2.ZERO
			player.animation.play("animation_idle")

			# pour montrer le game over
			if game_over_label:
				game_over_label.visible = true
			if restart_button:
				restart_button.visible = true
				if not restart_connected:
					restart_button.pressed.connect(_on_restart_pressed)
					restart_connected = true

func _on_restart_pressed():
	get_tree().reload_current_scene()
