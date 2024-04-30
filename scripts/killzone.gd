extends Area2D

@onready var timer = $Timer
@onready var hurt_sound = $HurtSound

func _on_body_entered(body):
	Engine.time_scale = 0.3
	body.get_node('CollisionShape2D').queue_free()
	timer.start()
	hurt_sound.play()

func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()