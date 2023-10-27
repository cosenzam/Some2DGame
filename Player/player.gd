extends CharacterBody2D

@export var speed = 180.0
@export var jumpVelocity = -350.0
@export var slopeSpeed = 250.0
@export var againstSlopeSpeed = 120.0
var inputEnabled = true # false if dead or loading/some cutscene or smth

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 0.9
var jumpCount = 1 # count for double jump
var globalVars
var max = 0

func _physics_process(delta):
	#print("FPS %d" % Engine.get_frames_per_second())
	#print(max)
	#if velocity.y > max:
		#max = velocity.y
	
	# Track player position in global variable
	globalVars.set_player_position(self)
	
	# Add the gravity.
	if not is_on_floor() and inputEnabled:
		# max y velocity
		var yVelocityTmp = velocity.y + (gravity * delta)
		if yVelocityTmp >= 250:
			velocity.y = 250
		else:
			velocity.y += gravity * delta
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")
			
	# jump stuff
	if is_on_floor():
		jumpCount = 1
		if Input.is_action_just_pressed("jump") and inputEnabled:
			jump()
	if Input.is_action_just_pressed("jump") and not is_on_floor() and jumpCount > 0 and inputEnabled:
		double_jump()
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction and get_floor_normal().x == 0 and inputEnabled:
		velocity.x = direction * speed
		if is_on_floor():
			$AnimatedSprite2D.play("run")
	elif get_floor_normal().x == 0:
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor() and inputEnabled:
			$AnimatedSprite2D.play("idle")
			
	# slope stuff
	if get_floor_normal().x < 0 and inputEnabled: # slope left => right
		if direction == 1: # can only walk against slope, free fall otherwise
			velocity.x = direction * againstSlopeSpeed # move forward when holding a direction against slope
			$AnimatedSprite2D.play("run")
		else:
			velocity = Vector2(-1, 1).normalized() * slopeSpeed # idk anymore, seems 1:1
			$AnimatedSprite2D.play("fall")
		if Input.is_action_just_pressed("jump"): # jump while on slope
			jump()
	elif get_floor_normal().x > 0 and inputEnabled: # slope right -> left
		if direction == -1:
			velocity.x = direction * againstSlopeSpeed
			$AnimatedSprite2D.play("run")
		else:
			velocity = Vector2(1, 1).normalized() * slopeSpeed
			$AnimatedSprite2D.play("fall")
		if Input.is_action_just_pressed("jump"):
			jump()
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		
	move_and_slide()

# Player functions
func killed_enemy():
	jump()
	
func jump():
	velocity.y = jumpVelocity

func double_jump():
	velocity.y = jumpVelocity
	jumpCount -= 1

func _on_tree_entered():
	globalVars = $"/root/Global"
