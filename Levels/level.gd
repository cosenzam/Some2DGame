extends Node2D

var animations = load("res://Animations/animations.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_debug_collisions_hint(true) 
	get_tree().is_debugging_collisions_hint()
	$"/root/Global".set_level_node(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
func _on_y_kill_border_body_entered(body):
	# kill border collision layer 2 -> player and enemies layer
	if body.name == "Player":
		kill_player()
	elif "Enemy" in body.name:
		kill_enemy_animation(body.global_position)
		print("killed enemy from falling")
		body.queue_free()

func kill_player():
	
	if $Player.inputEnabled:
		#remove player collision and stop velocity to stop physics, play death animation
		#$Player.velocity = Vector2(0, 0)
		#$Player.remove_child($Player/CollisionShape2D)
		#$Player/AnimatedSprite2D.play("death")
		#$Player.inputEnabled = false
		
		#await $Player/AnimatedSprite2D.animation_finished
		#$GameOver/Control.show()
		#$Player/AnimatedSprite2D.hide()
		
		# alternative player death node
		# set new animation node to current player pos from global variables
		$Player.inputEnabled = false
		$Player.velocity = Vector2(0, 0)
		$Player.hide()
		$Player.remove_child($Player/CollisionShape2D)
		var scene_animations = animations.instantiate()
		self.add_child(scene_animations)
		scene_animations.global_position = $"/root/Global".get_player_position()
		scene_animations.play("player_death")
		await scene_animations.animation_finished
		self.remove_child(scene_animations)
		$GameOver/Control.show()
	else:
		print("player already ded")
	
# add and remove enemy death anmiation	
func kill_enemy_animation(enemyNodePosition):
	var scene_animations = animations.instantiate()
	self.add_child(scene_animations)
	print("node appended")
	scene_animations.global_position = enemyNodePosition
	scene_animations.play("enemy_death")
	await scene_animations.animation_finished
	self.remove_child(scene_animations)
	print("node removed")
	
func item_collected_animation(itemNodePosition):
	var scene_animations = animations.instantiate()
	self.add_child(scene_animations)
	print("node appended")
	scene_animations.global_position = itemNodePosition
	scene_animations.play("item_collected")
	await scene_animations.animation_finished
	self.remove_child(scene_animations)
	print("node removed")
