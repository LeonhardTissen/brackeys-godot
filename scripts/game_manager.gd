extends Node

var score = 0

var current_level = 1

func _ready():
	go_to_next_level()
	print("Game started", _get_next_level_path())

func _get_next_level_path():
	return 'res://scenes/levels/level%s.tscn' % current_level

func go_to_next_level():
	current_level += 1
	var next_level_path = _get_next_level_path()
	print(next_level_path)
	get_tree().change_scene_to_file(next_level_path)

func add_point():
	score += 1
	print(score)
	if score == 60:
		go_to_next_level()
