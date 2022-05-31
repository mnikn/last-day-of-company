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
	yield($Dialogue.start_custom("..经理,虽然需要交接工作的兄弟都升天了."), "completed")
	yield($Dialogue.start_custom("但是我没功劳也有苦劳."), "completed")
	yield($Dialogue.start_custom("既然公司都裁了这么多人,要不给我加下薪安抚下人心?"), "completed")
	
	$Dialogue.rect_global_position = Vector2(552, 190)
	yield($Dialogue.start_custom("正好,刚刚接到上头的通知."), "completed")
	yield($Dialogue.start_custom("你也在裁员名单里."), "completed")
	
	$Dialogue.rect_global_position = Vector2(397, 256)
	yield($Dialogue.start_custom("...他奶奶的,给我玩阴的是吧!"), "completed")
	yield($Dialogue.start_custom("我选择直接去世!"), "completed")

	SceneChanger.change_scene("res://StoryCombat3.tscn")
