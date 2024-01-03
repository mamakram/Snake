extends Node

var direction = Vector2(1,0)
var snake = []
var counter = 0
const x_bound:int = 36
const y_bound:int = 20
const counter_limit:int = 12
const tile_size:int = 32
const rotation_table = [0,180,90,270]
var map = []
var ate=false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_body()
	add_body()
	spawn_food()

func spawn_food():
	var scene
	if randf()<0.7:
		scene = load("res://food.tscn")
	else :
		scene = load("res://spider.tscn")
	var new_child = scene.instantiate()
	self.get_parent().get_node("Foods").add_child.call_deferred(new_child)

func add_body():
	var scene = load("res://body.tscn")
	var new_child = scene.instantiate()
	snake.append(new_child)
	if snake.size()==1:
		snake[0].position = self.position -tile_size * direction	
	else:
		snake[-1].position = snake[-2].position
		snake[-1].rotation = snake[-2].rotation
		snake[-1].get_node("bodypart").frame=1
	self.get_parent().add_child.call_deferred(snake[-1])
	

		
func lose():
	get_tree().paused = true
	var scene = load("res://game_over.tscn")
	var window = scene.instantiate()
	self.get_parent().add_child.call_deferred(window)

func replay():
	for elem in snake:
		elem.queue_free()
	snake = []
	direction = Vector2(1,0)
	self.position = Vector2(16,16)
	add_body()
	add_body()



func move(move):
	if counter >= max(5,(counter_limit-snake.size()/6)) or move!=direction:
		direction = move
		for i in range(1,snake.size()):
			snake[-i].get_node("bodypart").frame=snake[-i-1].get_node("bodypart").frame
			snake[-i].position = snake[-i-1].position
			snake[-i].rotation = snake[-i-1].rotation
		snake[0].position = self.position
		snake[0].rotation = self.rotation
		snake[-1].get_node("bodypart").frame=1
		snake[-1].rotation = snake[-2].rotation
		self.position +=direction*tile_size
		self.position.x = posmod(int(self.position.x), x_bound*tile_size)
		self.position.y = posmod(int(self.position.y), y_bound*tile_size)
		var rot = rotation_table[posmod(direction[0],3)-abs(direction[0])+abs(direction[1])+posmod(direction[1],3)]
		self.rotation = deg_to_rad(rot)
		
		if snake[0].rotation != self.rotation:
			var diff = snake[0].rotation - self.rotation
			if (diff >-2 and diff<0) or diff>2:
				snake[0].get_node("bodypart").frame = 2
			else:
				snake[0].get_node("bodypart").frame = 3
		else:
			snake[0].get_node("bodypart").frame = 0
			if ate:
				snake[0].get_node("bodypart").frame=4
				ate=false
		counter = 0
	else:
		counter+=1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move = direction
	if Input.is_action_pressed("up"):
		move = Vector2(0,-1)
	elif Input.is_action_pressed("down"):
		move = Vector2(0,1)
	elif Input.is_action_pressed("left"):
		move = Vector2(-1,0)
	elif Input.is_action_pressed("right"):
		move = Vector2(1,0)
	
	if direction+move==Vector2(0,0):
		move = direction
	move(move)
	
	


func _on_rigid_body_2d_body_entered(body):
	if body.get_parent().is_in_group("Food"):
		for i in range(body.get_parent().reward):
			add_body()
		ate=true
		spawn_food()
	else:
		lose()
