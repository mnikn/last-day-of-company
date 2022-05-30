extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


#var DialogueScene = preload("res://ui/Dialogue.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.start()


func start():
	$Dialogue/SoundEffectPlayer.volume_db = 1.0
	$SoundEffectPlayer.stream = load("res://assets/musics/sound_effects/typewriter.wav")
	$SoundEffectPlayer.play()
	$Dialogue.rect_global_position = Vector2(790, 55)
	var tween = Tween.new()
	self.add_child(tween)
	
	$Scene.frame = 0
	$Scene.animation = "work"
	$Scene.play()
	
	yield(self.get_tree().create_timer(2.0), "timeout")
	tween.interpolate_property($SoundEffectPlayer, "volumb_db", $SoundEffectPlayer.volume_db, -9999, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	$SoundEffectPlayer.stop()
	
	$SoundEffectPlayer.volume_db = 1.0
	$SoundEffectPlayer.stream = load("res://assets/musics/sound_effects/door_open.wav")
	$SoundEffectPlayer.play()
	$Scene.animation = "boss_show"
	$Scene.play()
	yield($Scene, "animation_finished")
	
	
	
	yield($Dialogue.start_custom("通知一个不幸的消息."), "completed")
	yield($Dialogue.start_custom("由于资金问题,我们公司决定进行一下人员\"优化\"."), "completed")
	yield($Dialogue.start_custom("在这里的80%员工都需要\"毕业\"."), "completed")
	yield($Dialogue.start_custom("虽然公司对于失去你们这些人很不舍."), "completed")
	yield($Dialogue.start_custom("但是把你们这些经验丰富的人输送到其他企业做贡献."), "completed")
	yield($Dialogue.start_custom("也是公司应尽的义务."), "completed")
	yield($Dialogue.start_custom("恭喜你们,毕业了."), "completed")
	
	$Dialogue.rect_global_position = Vector2(810, 184)
	yield($Dialogue.start_custom("我的天,能不能选择留校?"), "completed")
	$Dialogue.rect_global_position = Vector2(790, 55)
	yield($Dialogue.start_custom("不能."), "completed")
	$Scene.animation = "ghost_1"
	$Scene.play()
	yield($Scene, "animation_finished")
		
	$Dialogue.rect_global_position = Vector2(648, 264)
	yield($Dialogue.start_custom("可以缓冲一个月时间让我们找工作吗?"), "completed")
	$Dialogue.rect_global_position = Vector2(790, 55)
	yield($Dialogue.start_custom("不能."), "completed")
	$Scene.animation = "ghost_2"
	$Scene.play()
	yield($Scene, "animation_finished")
	
	$Dialogue.rect_global_position = Vector2(468, 360)
	yield($Dialogue.start_custom("赔偿是2n吗?"), "completed")
	$Dialogue.rect_global_position = Vector2(790, 55)
	yield($Dialogue.start_custom("不,n+1."), "completed")
	$Scene.animation = "ghost_3"
	$Scene.play()
	yield($Scene, "animation_finished")
	
	$Dialogue.rect_global_position = Vector2(393, 126)
	yield($Dialogue.start_custom("虽然是个令人震惊的消息."), "completed")
	yield($Dialogue.start_custom("也不至于吓到当场逝世吧..."), "completed")
	
	SceneChanger.change_scene("res://Opening2.tscn")
