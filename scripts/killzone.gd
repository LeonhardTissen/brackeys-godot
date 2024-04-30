extends Area2D

@onready var hurt_sound = $HurtSound
@onready var player = %Player

func _on_body_entered(body):
	body.kill()

