extends Node2D

@onready var fail_audio = $FailAudio

func _ready():
	fail_audio.play()
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
