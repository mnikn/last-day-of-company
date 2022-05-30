extends Panel
signal dialogue_finished()

var player_contents = {
	"reason": [{
		"zh": "现在摸鱼只会影响下家公司对你的评价啊~",
		"en": ""
	}, {
		"zh": "好好完成交接工作这样下家公司对你的评价也高~",
		"en": ""
	}, {
		"zh": "听说被人证实摸鱼会被扣工资的~",
		"en": ""
	}],
	"empathy": [{
		"zh": "你跑路了也要考虑下我们接手烂摊子的感受啊~",
		"en": ""
	}, {
		"zh": "打工人何苦为难打工人,你就让我好好交接吧~",
		"en": ""
	}],
	"threaten": [{
		"zh": "你信不信我去你下家公司告状~",
		"en": ""
	}, {
		"zh": "你再摸鱼我就让你连n+1都拿不到~",
		"en": ""
	}],
	"ignore": [{
		"zh": "....(这时候先静观其变吧)",
		"en": ""
	}],
	"think": [{
		"zh": "...(再考虑下要怎么说服吧)",
		"en": ""
	}],
	"sophistry": [{
		"zh": "自己都做不好的话,有什么资格说别人?",
		"en": ""
	}]
}

var enemy_contents = {
	"reason": [{
		"zh": "我最近加班到腰酸背痛,实在没办法再工作~",
		"en": ""
	}, {
		"zh": "反正我怎么摆烂都不会影响接下来的结果~",
		"en": ""
	}],
	"empathy": [{
		"zh": "你也想想我这种被裁员的人的心情啊~",
		"en": ""
	}, {
		"zh": "下班还要花精力照顾小孩,实在没精力工作~",
		"en": ""
	}],
	"threaten": [{
		"zh": "老子就是摆烂怎么了,有种你来打我啊~",
		"en": ""
	}, {
		"zh": "信不信我在代码藏屎,让你接下来更难受~",
		"en": ""
	}, {
		"zh": "你再说一句我就直接删库跑路~",
		"en": ""
	}],
	"ignore": [{
		"zh": "....(只要我不回答我就是无敌的)",
		"en": ""
	}],
	"think": [{
		"zh": "...(再考虑下要怎么样才能名正言顺地摸鱼吧)",
		"en": ""
	}],
	"sophistry": [{
		"zh": "这么喜欢工作莫非你是精神资本家?",
		"en": ""
	}, {
		"zh": "一时摆烂一时爽,一直摆烂一直爽~",
		"en": ""
	}, {
		"zh": "摆得烂中烂,方为人上人~",
		"en": ""
	}]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = Color("#00ffffff")
	$MarginContainer/RichTextLabel.percent_visible = 0.0

func start(action, player):
	$SoundEffectPlayer.play()
	var contents = self.player_contents if player else enemy_contents
	var content = I18n.translate(contents[action.id][randi() % len(contents[action.id])])
	$MarginContainer/RichTextLabel.text = content
	
	var tween = Tween.new()
	$MarginContainer/RichTextLabel.percent_visible = 0.0
	self.modulate = Color("#00ffffff")
	self.add_child(tween)
	
	tween.interpolate_property(self, "modulate", self.modulate, Color("#ffffff"), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property($MarginContainer/RichTextLabel, "percent_visible", $MarginContainer/RichTextLabel.percent_visible, 1.0, 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	$SoundEffectPlayer.stop()
	yield(self.get_tree().create_timer(0.5), "timeout")
	
	tween.interpolate_property(self, "modulate", self.modulate, Color("#00ffffff"), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()
	
	self.emit_signal("dialogue_finished")
