class_name EnemyActions

#var EnemyActions = load("res://Enemies/enemy_actions.gd").new(enemyNode, enemyName, enemyDict)
# add to _on_tree_entered(): globalVars = $"/root/PlayerGlobal"
# enemies are on layers 1 and 2, 1 is world collision, 2 is kill boundary collision

# init vars
var enemyNode
var enemyName
var enemyDict

func _init(enemyNode, enemyName, enemyDict):
	self.enemyNode = enemyNode
	self.enemyName = enemyName
	self.enemyDict = enemyDict

# Movement
func jump(direction = enemyNode.direction):
	enemyNode.velocity.y = enemyDict["jumpVelocity"]
	enemyNode.velocity.x = direction * enemyDict["speed"]

# e.g. : patrol(self, "Frog", frogVars)
func patrol():
	match (enemyName): # unique movement e.g jumping, flying
		# jump back and forth every moveTime seconds
		"Frog":
			if enemyNode.time >= enemyDict["moveTime"] and enemyNode.is_on_floor():
				enemyNode.velocity.y = enemyDict["jumpVelocity"]
				enemyNode.velocity.x = enemyNode.direction * enemyDict["speed"]
				enemyNode.direction *= -1.0
				enemyNode.time = 0.0
		# change directions every moveTime seconds
		"Opossum":
			enemyNode.velocity.x = enemyNode.direction * enemyDict["speed"]
			if enemyNode.time >= enemyDict["moveTime"]:
				enemyNode.direction *= -1.0
				enemyNode.time = 0.0
		"Eagle":
			# jump/fly when velocity.y >= some val
			enemyNode.velocity.x = enemyNode.direction * enemyDict["speed"]
			if enemyNode.jumpCount > 0 and enemyNode.global_position.y >= enemyDict["yMinJump"]:
				jump()
				enemyNode.jumpCount -= 1
			if enemyNode.jumpCount <= 0:
				enemyNode.jumpCount = enemyDict["jumpCount"]
				enemyNode.direction *= -1.0
		_:
			print("Invalid enemy name for patrolling")

# Enemy chase and aggro behavior
func chase_player(globalVars):
	match (enemyName):
		"Frog":
			if enemyNode.time >= enemyDict["moveTime"] and enemyNode.is_on_floor():
				if get_player_position(globalVars).x > get_enemy_position(enemyNode).x:
					enemyNode.velocity.y = enemyDict["jumpVelocity"]
					enemyNode.direction = 1.0
					enemyNode.velocity.x = enemyNode.direction * enemyDict["speed"]
					enemyNode.time = 0.0
				else:
					enemyNode.velocity.y = enemyDict["jumpVelocity"]
					enemyNode.direction = -1.0
					enemyNode.velocity.x = enemyNode.direction * enemyDict["speed"]
					enemyNode.time = 0.0
		"Eagle":
			# get player position as soon as they enter range, stop moving and charge at that range after n seconds
			# slowly fly back to starting position and start patrol from default values, able to aggro again after
			pass
		_:
			print("Invalid enemy name for chasing")
			
func get_enemy_position(globalVars):
	var enemyPosition = enemyNode.global_position
	return enemyPosition
	
func get_player_position(globalVars):
	var playerPosition = globalVars.get_player_position()
	return playerPosition

# kill player hitbox
func kill_player(globalVars):
	globalVars.get_level_node().kill_player()
	if enemyName == "Frog" and not enemyNode.is_on_floor():
		if get_player_position(globalVars).x > get_enemy_position(enemyNode).x:
			jump(1.0)
		else:
			jump(-1.0)
		
# kill enemy hurtbox
func kill_enemy(playerNode, globalVars):
	# original kill enemy code
	'''
	enemyNode.isDead = true
	playerNode.killed_enemy()
	enemyNode.collision_layer = 0
	enemyNode.call_deferred("remove_child", enemyNode.get_node("Hitbox"))
	enemyNode.call_deferred("remove_child", enemyNode.get_node("Hurtbox"))
	enemyNode.call_deferred("remove_child", enemyNode.get_node("AggroCircle"))
	enemyNode.get_node("AnimatedSprite2D").play("death")
	await enemyNode.get_node("AnimatedSprite2D").animation_finished
	enemyNode.queue_free()
	'''
	
	# new kill enemy code
	playerNode.killed_enemy()
	globalVars.get_level_node().kill_enemy_animation(enemyNode.global_position)
	enemyNode.queue_free()
	
# Animations
func animate():
	match (enemyName):
		"Frog":
			if enemyNode.is_on_floor() and enemyNode.velocity.x == 0:
				enemyNode.get_node("AnimatedSprite2D").play("idle")
			
			if enemyNode.velocity.y < 0:
				enemyNode.get_node("AnimatedSprite2D").play("jump")
			elif enemyNode.velocity.y > 0:
				enemyNode.get_node("AnimatedSprite2D").play("fall")
		"Opossum", "Eagle":
			enemyNode.get_node("AnimatedSprite2D").play("patrol")
		_:
			print("Invalid enemy name for animate")
			
	if enemyNode.velocity.x < 0:
		enemyNode.get_node("AnimatedSprite2D").flip_h = false
	elif enemyNode.velocity.x > 0:
		enemyNode.get_node("AnimatedSprite2D").flip_h = true

