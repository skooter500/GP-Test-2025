extends CharacterBody2D

@export var speed:float = 100

func _physics_process(delta: float) -> void:
	velocity.x = -speed
	var c:KinematicCollision2D = move_and_collide(velocity * delta)
	if c:
		var other = c.get_collider()
		if other.is_in_group("player"):
			print("hit player")
			
