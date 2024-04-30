extends Node

var score = 0

@onready var score_label = $ScoreLabel

func add_point():
	score += 1
	print(score)
	var adjective = ''
	if score == 30:
		adjective = 'all'
	elif score < 10:
		adjective = 'only'
		
	var s_end = 's' if score != 0 else ''
	score_label.text = 'You collected %s %s coin%s.' % [adjective, score, s_end]
