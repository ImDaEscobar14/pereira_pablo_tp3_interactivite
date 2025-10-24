extends CharacterBody2D
class_name Player
var speed = 400.0;

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var pas_son = $AudioStreamPlayer2D
@onready var hitbox_player = CollisionShape2D
@onready var menu_pause = $Camera2D/MenuPause
@onready var reprendre_button = menu_pause.get_node("VBoxContainer/Reprendre")
@onready var quitter_button = menu_pause.get_node("VBoxContainer/Quitter")
static var instance = null

var paused = false

func _ready():
	reprendre_button.pressed.connect(_on_reprendre_pressed)
	quitter_button.pressed.connect(_on_quitter_pressed)
	instance = self
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
		
func toggle_pause():
	paused = !paused
	menu_pause.visible = paused
	Engine.time_scale = 0 if paused else 1
	
func _on_reprendre_pressed():
		paused = false
		menu_pause.visible = false
		Engine.time_scale = 1
		
func _on_quitter_pressed():
		get_tree().quit()


const SPEED = 75.0

var directionName = "bas";
#les mouvements du player
func _physics_process(_delta) -> void:

	var direction = Vector2(
		Input.get_axis("gauche", "droite"),
		Input.get_axis("haut", "bas")
	)

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
		#le son du player qui bouge
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.pitch_scale = randf_range(0.8, 1.4)
			$AudioStreamPlayer2D.play()
	else:
		velocity = Vector2.ZERO
		#le son du player quand il arrete de bouger
		if $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.stop()
			
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				directionName = "droite";
			else:
				directionName = "gauche";
				
		else:
			if direction.y < 0:
				directionName = "haut";
			else:
				directionName = "bas";
				
	if direction == Vector2.ZERO:
		if directionName == "haut":
			animation.play("animation_idle");
			
		if directionName == "gauche":
			animation.play("animation_idle_gauche");
			
		if directionName == "droite":
			animation.play("animation_idle_droite");
	#animation qui fait bouger
	else:
		animation.play("animation_" + directionName);
		
	move_and_slide()
