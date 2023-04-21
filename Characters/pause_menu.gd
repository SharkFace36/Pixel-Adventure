extends CanvasLayer


@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var resume: Button = find_child("ResumeBtn")
@onready var quit: Button = find_child("QuitBtn")

func _ready():
	resume.pressed.connect(unpause)
	quit.pressed.connect(get_tree().quit)
	animator.play("Pause")
	resume.grab_focus()
	
func unpause():
	get_tree().paused = false
	queue_free()
