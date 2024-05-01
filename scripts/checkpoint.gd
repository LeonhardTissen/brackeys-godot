extends Area2D

@onready var checkpoint_sound = $CheckpointSound

func _on_body_entered(body):
	checkpoint_sound.play()
	body.set_new_checkpoint()

