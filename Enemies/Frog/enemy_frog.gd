extends CharacterBody2D

@export var speed = 150.0
@export var airControl = 10.0
@export var jumpVelocity = -400.0
@export var moveTime = 3
@export var direction = 1.0
var xNegDeceleration = -1 * airControl # * delta | decelerate toward -x
var xPosDeceleration = 1 * airControl  # * delta

var frogVarsDict
var time = 0.0
var chase = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var globalVars
var EnemyActions

func _physics_process(delta):
	
	# Gravity and air deceleration
	if not is_on_floor():
		var yVelocityTmp = velocity.y + (gravity * delta)
		if yVelocityTmp >= 250:
			velocity.y = 250
		else:
			velocity.y += gravity * delta
		if velocity.x > 0:
			velocity.x += xNegDeceleration * delta
		elif velocity.x < 0:
			velocity.x += xPosDeceleration * delta
	elif velocity.y == 0: # needed for x velocity when killing player
		velocity.x = 0
	
	EnemyActions.animate()
	
	time += delta
	if not chase:
		EnemyActions.patrol()
	else:
		EnemyActions.chase_player(globalVars)

	move_and_slide()

func _on_aggro_circle_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_aggro_circle_body_exited(body):
	if body.name == "Player":
		chase = false
		
func _on_hitbox_body_entered(body):
	if body.name == "Player":
		print(str(body.name), " ded")
		EnemyActions.kill_player(globalVars)

func _on_hurtbox_body_entered(body):
	if body.name == "Player":
		print(self.name, " ded")
		EnemyActions.kill_enemy(body, globalVars)
		
func _on_tree_entered():
	frogVarsDict = {"speed": speed, "airControl": airControl, "jumpVelocity": jumpVelocity, "moveTime": moveTime}
	EnemyActions = load("res://Enemies/enemy_actions.gd").new(self, "Frog", frogVarsDict)
	globalVars = $"/root/Global"
