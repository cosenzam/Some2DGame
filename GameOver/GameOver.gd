extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_panel_retry_gui_input(event):
	if Input.is_action_just_released("left_click"):
		get_tree().reload_current_scene()

func _on_panel_quit_gui_input(event):
	if Input.is_action_just_released("left_click"):
		get_tree().quit()
