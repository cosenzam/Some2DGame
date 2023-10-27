extends Node

var playerPosition
var levelNode

func set_player_position(node):
	playerPosition = node.global_position

func get_player_position():
	return playerPosition

func set_level_node(node):
	levelNode = node

func get_level_node():
	return levelNode
