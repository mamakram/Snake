extends Node
@export var level:OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_pressed():
	var scene
	match level.get_selected_id():
		0:
			scene = load("res://level1.tscn")
		1:
			scene = load("res://level2.tscn")
		2:
			scene = load("res://level3.tscn")
	var game = scene.instantiate()
	self.add_child.call_deferred(game)
	

func _on_quit_pressed():
	get_tree().quit()
