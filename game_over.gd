extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = self.get_node("AudioStreamPlayer2D")
	player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_replay_pressed():
	self.get_parent().get_node("Player").replay()
	get_tree().paused=false
	self.queue_free()
	
func _on_quit_pressed():
	get_tree().paused=false
	self.get_parent().queue_free()
