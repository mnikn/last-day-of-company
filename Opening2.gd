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
	yield($Dialogue.start_custom("朋友虽然你逝世了也被裁了."), "completed")
	yield($Dialogue.start_custom("但是我还需要在这里工作,一些工作上的东西能不能交接一下?"), "completed")
	
	$Dialogue.rect_global_position = Vector2(559, 146)
	yield($Dialogue.start_custom("不,我选择摸鱼."), "completed")
	yield($Dialogue.start_custom("公司欺人太甚!"), "completed")
	
	$Dialogue.rect_global_position = Vector2(397, 256)
	yield($Dialogue.start_custom("....(干!!看来需要一番战斗才能完成交接了)"), "completed")

	SceneChanger.change_scene("res://StoryCombat1.tscn")
