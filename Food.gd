extends Node2D
const tile_size:int = 32
const x_bound:int=35
const y_bound:int=19
var reward=1

# Called when the node enters the scene tree for the first time.
func _ready():
	#spawn food at random position
	var x = (randi_range(0,x_bound)*tile_size)+tile_size/2
	var y = (randi_range(0,y_bound)*tile_size)+tile_size/2
	self.position = Vector2(x,y)
	print("pos:",position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rigid_body_2d_body_entered(body):
	if body.is_in_group("Walls") or body.get_parent().is_in_group("Food"):
		var scene
		if randf()<0.7:
			scene = load("res://food.tscn")
		else :
			scene = load("res://spider.tscn")
		var new_child = scene.instantiate()
		self.get_parent().add_child.call_deferred(new_child)
		self.queue_free()
		print("retry")
	elif body.get_parent().is_in_group("Player"):#player collision
		self.queue_free()
		print('ate')
