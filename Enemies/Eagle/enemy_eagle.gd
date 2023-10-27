extends CharacterBody2D

# this is no good! starting point is not the ending point in a full patrol cycle
# some sine wave or smth is better surely
@export var speed = 80.0
@export var jumpVelocity = -200.0
@export var direction = 1.0
## positive values only, jump at some y value lower (game world) than node starting global_position
@export_range(0, 100) var jumpAtDifference = 40.0
## number of jumps before enemy will change directions
@export var jumpCount = 3
## max velocity of positive y/gravity (down)
@export var yPosMaxVelocity = 35.0
@export_range(0.1, 2) var gravityScale = 0.7

var eagleVarsDict
var chase = false
var attackFinished
var time = 0.0
var globalVars
var EnemyActions
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var startingPosition
var yMinJump
var playerExited # check if player is still in aggro range after attack is finished

func _physics_process(delta):
	
	time += delta
	if not chase:
		if not is_on_floor():
			# max falling velocity
			if velocity.y > yPosMaxVelocity:
				velocity.y = yPosMaxVelocity
			# Gravity scaled
			velocity.y += gravity * gravityScale * delta
		
		EnemyActions.patrol()
	else:
		velocity = Vector2(0, 0)
		if time >= 3:
			# attack at player position
			# move back to starting position
			# reset jump counts and direction to startingDirection
			
			# time = 0 
			# if self.global_position == startingPosition:
				# if playerExited, chase = false
			chase = false
			print("no longer chasing")
		
	EnemyActions.animate()

	move_and_slide()

func _on_hitbox_body_entered(body):
	if body.name == "Player":
		print(str(body.name), " ded")
		EnemyActions.kill_player(globalVars)

func _on_hurtbox_body_entered(body):
	if body.name == "Player":
		print(self.name, " ded")
		EnemyActions.kill_enemy(body, globalVars)
	elif "TileMap" in body.name:
		# go back to starting position, a wall was hit
		# chase = false
		pass
		
		
func _on_aggro_body_entered(body):
	if body.name == "Player":
		if not chase:
			print(body.name, " in range")
			time = 0
			chase = true
		playerExited = false
		
func _on_aggro_body_exited(body):
	if body.name == "Player":
		print(body.name, " exited range")
		playerExited = true
	
func _on_tree_entered():
	startingPosition = self.global_position
	yMinJump = startingPosition.y + jumpAtDifference
	eagleVarsDict = {"speed": speed, "jumpVelocity": jumpVelocity, "jumpCount": jumpCount, "yMinJump": yMinJump}
	EnemyActions = load("res://Enemies/enemy_actions.gd").new(self, "Eagle", eagleVarsDict)
	globalVars = $"/root/Global"
