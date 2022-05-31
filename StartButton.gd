extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_mouse_entered():
	self.material.set_shader_param("light", 1.3)


func _on_StartButton_mouse_exited():
	self.material.set_shader_param("light", 1.0)


func _on_StartButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			SceneChanger.change_scene("res://Opening.tscn")
