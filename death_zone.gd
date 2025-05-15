extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("enemy die")
		body.queue_free()
	pass # Replace with function body.
