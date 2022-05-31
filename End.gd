extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.percent_visible = 0
	var tween = Tween.new()
	tween.interpolate_property($Label, "percent_visible", $Label.percent_visible, 1.0, 10.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	self.add_child(tween)
	
	tween.start()
	
	yield(tween, "tween_all_completed")


	yield(self.get_tree().create_timer(4.0), "timeout")
	SceneChanger.change_scene("res://StartMenu.tscn")
