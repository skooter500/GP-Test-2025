extends CharacterBody2D

@export var speed:float = 300

func _physics_process(delta: float) -> void:
	
	var lr := Input.get_axis("left", "right")
	var ud := Input.get_axis("up", "down")
	velocity.x = speed * lr
	velocity.y = speed * ud
	move_and_slide()
