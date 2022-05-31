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
	yield($Dialogue.start_custom("好了,上一位仁兄已经被我说到升天了."), "completed")
	yield($Dialogue.start_custom("接下来,你能不能协助我完成下交接?"), "completed")
	
	$Dialogue.rect_global_position = Vector2(559, 146)
	yield($Dialogue.start_custom("交接个鬼!"), "completed")
	yield($Dialogue.start_custom("我要摸鱼摸到天荒地老!"), "completed")
	
	$Dialogue.rect_global_position = Vector2(397, 256)
	yield($Dialogue.start_custom("....(为什么每个鬼都这样)"), "completed")

	SceneChanger.change_scene("res://StoryCombat2.tscn")
