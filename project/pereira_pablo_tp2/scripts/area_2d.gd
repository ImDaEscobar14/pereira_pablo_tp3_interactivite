extends Area2D

@export var zoom_in_value := Vector2(5,5)
@export var zoom_out_value := Vector2(3, 3)

# quand on rentre
func _on_body_entered(body):
	print("Entré :", body)  
	var camera = body.get_node("Camera2D")
	if camera:
		camera.zoom = zoom_in_value
# quand on sort
func _on_body_exited(body):
	print("Sorti :", body)
	var camera = body.get_node("Camera2D")
	if camera:
		camera.zoom = zoom_out_value
