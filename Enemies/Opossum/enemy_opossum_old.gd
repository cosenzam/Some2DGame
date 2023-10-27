extends Area2D

var time = 0
@export var move_time = 1
@export var speed = 90
@export var starting_direction = -1
var direction = starting_direction
var move_speed = Vector2(speed, 0)
var player
var level
var isDead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("patrol")
	level = get_node("../../../Level")
	player = get_node("../../Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# patrol behavior on timer
	time += delta
	if not isDead:
		position += direction * move_speed * delta
		if time >= move_time:
			direction *= -1
			time = 0
			if direction == -1:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
	
# enemy hitbox
func _on_body_entered(body):
	if body.name == "Player":
		print(str(body.name), " ded")
		level.kill_player()

# enemy hurtbox
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		print("enemy ded")
		kill_opossum()
		
func kill_opossum():
	isDead = true
	player.killed_enemy()
	self.remove_child($Hitbox)
	self.call_deferred("remove_child", $Area2D)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()
