extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(self.get_tree().create_timer(0.2), "timeout")
	self.start()


func start():
	$Dialogue.rect_global_position = Vector2(397, 256)
	yield($Dialogue.start_custom("...乖乖完成交接吧."), "completed")
	yield($Dialogue.start_custom("你也不想像之前那两个朋友一样升天吧."), "completed")
	
	$Dialogue.rect_global_position = Vector2(559, 146)
	yield($Dialogue.start_custom("升天就升天!我怕个锤子!"), "completed")
	
	$Dialogue.rect_global_position = Vector2(397, 256)
	yield($Dialogue.start_custom("....(再这样下去我怕要成为道士了)"), "completed")

	SceneChanger.change_scene("res://StoryCombat3.tscn")
