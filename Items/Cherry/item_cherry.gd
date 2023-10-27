extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play("default")
	
func _on_body_entered(body):
	if body.name == "Player":
		print(self.name, " collected")
		$"/root/Global".get_level_node().item_collected_animation(self.global_position)
		self.queue_free()
