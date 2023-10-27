extends CharacterBody2D

@export var speed = 90.0
@export var moveTime = 1
@export var direction = -1.0

var opossumVarsDict
var time = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var globalVars
var EnemyActions

func _physics_process(delta):

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	EnemyActions.animate()
	
	time += delta
	EnemyActions.patrol()

	move_and_slide()
		
func _on_hitbox_body_entered(body):
	if body.name == "Player":
		print(str(body.name), " ded")
		EnemyActions.kill_player(globalVars)
	
func _on_hurtbox_body_entered(body):
	if body.name == "Player":
		print(self.name, " ded")
		EnemyActions.kill_enemy(body, globalVars)

func _on_tree_entered():
	# re-assign export values lamo!
	opossumVarsDict = {"speed": speed, "moveTime": moveTime}
	EnemyActions = load("res://Enemies/enemy_actions.gd").new(self, "Opossum", opossumVarsDict)
	globalVars = $"/root/Global"
