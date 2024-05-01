extends Area2D

@onready var animation_player = $AnimationPlayer

@onready var game_manager = get_node("/root/GameManager")

func _on_body_entered(body):
	print('+1 Coin')
	game_manager.add_point()
	animation_player.play('pickup')
