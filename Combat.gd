extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var ActionScene = preload("res://ui/action/Action.tscn")
var DialogueScene = preload("res://ui/Dialogue.tscn")

var actions = []
var current_term_key_action = ""

export var difficult_coff = 2
export (String, FILE) var win_target_scene = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$ResultText.rect_global_position = Vector2(411, -400)
	randomize()
	self.actions = JsonUtils.load_json_file("res://data/action.json")
	self.start()
	
func start():
	self.next_term()

func next_term():
	print_debug("next_term_start")
	var tween = Tween.new()
	self.add_child(tween)
	for node in $UI/PlayerActionPanel.get_children():
		tween.interpolate_property(node, "modulate", node.modulate, Color("#ffffff"), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	for node in $UI/EmenyPanel.get_children():
		tween.interpolate_property(node, "modulate", node.modulate, Color("#ffffff"), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()
	
	if $UI/PlayerActionPanel.get_child_count() <= 0:
		self.generate_player_actions()
	if $UI/EmenyPanel.get_child_count() <= 0:
		self.generate_enemy_actions()
		
	var normal_actions = ArrayUtils.map(ArrayUtils.filter(actions, { "type": "normal" }), "id")
	current_term_key_action = normal_actions[randi() % len(normal_actions)]
	$UI/TermKeyPanel/Label.text = I18n.translate(ArrayUtils.find(actions, { "id": self.current_term_key_action }).name)
	print_debug("next_term_end")
	
func generate_player_actions():
	NodeUtils.clear_children($UI/PlayerActionPanel)
	var player_action = []
	var normal_actions = ArrayUtils.map(ArrayUtils.filter(actions, { "type": "normal" }), "id")
	var special_actions = ArrayUtils.map(ArrayUtils.filter(actions, { "type": "special" }), "id")
	
	var r1 = normal_actions[randi() % len(normal_actions)]
	var r2 = normal_actions[randi() % len(normal_actions)]
	
	player_action.append_array(normal_actions)
	player_action.insert(player_action.find(r1), r1)
	player_action.insert(player_action.find(r2), r2)
	
	player_action.push_back(special_actions[randi() % len(special_actions)])
	
	var val = 10
	for action in player_action:
		var node = self.ActionScene.instance()
		var data = DictUtils.copy(ArrayUtils.find(actions, { "id": action }))
		if data.type == "normal":
			val = max(randi() % val + 1, 3)
			if $UI/PlayerActionPanel.get_child_count() == 0:
				val = randi() % 4 + 6
			data.val = val
		else:
			data.val = 0
		node.player = true
		node.data = data
		node.modulate = Color("#00ffffff")
		node.connect("clicked", self, "on_action_selected", [node.data, node])
		$UI/PlayerActionPanel.add_child(node)
	
	yield(self.get_tree().create_timer(0.1), "timeout")
	var tween = Tween.new()
	self.add_child(tween)
	for node in $UI/PlayerActionPanel.get_children():
		var origin_pos = node.rect_global_position
		tween.interpolate_property(node, "rect_global_position", Vector2(-200, node.rect_global_position.y), origin_pos, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(node, "modulate", node.modulate, Color("#ffffff"), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()
	
func generate_enemy_actions():
	
	NodeUtils.clear_children($UI/EmenyPanel)
	var player_action = []
	var normal_actions = ArrayUtils.map(ArrayUtils.filter(actions, { "type": "normal" }), "id")
	var special_actions = ArrayUtils.map(ArrayUtils.filter(actions, { "type": "special" }), "id")
	
	randomize()
	var r1 = normal_actions[randi() % len(normal_actions)]
	var r2 = normal_actions[randi() % len(normal_actions)]
	
	player_action.append_array(normal_actions)
	if difficult_coff >= 4:
		player_action.insert(player_action.find(r1), r1)
	if difficult_coff >= 6:
		player_action.insert(player_action.find(r2), r2)
	
	player_action.push_back(special_actions[randi() % len(special_actions)])
	
	var val = 10
	for action in player_action:
		var node = self.ActionScene.instance()
		node.modulate = Color("#00ffffff")
		var data = ArrayUtils.find(actions, { "id": action })
		if data.type == "normal":
			val = max(randi() % val + 1, 3)
			if $UI/EmenyPanel.get_child_count() == 0:
				val = randi() % 4 + difficult_coff
			data.val = val
		else:
			data.val = 0
		node.player = false
		node.data = data
		$UI/EmenyPanel.add_child(node)
	
	yield(self.get_tree().create_timer(0.1), "timeout")
	var tween = Tween.new()
	self.add_child(tween)
	for node in $UI/EmenyPanel.get_children():
		var origin_pos = node.rect_global_position
		tween.interpolate_property(node, "rect_global_position", Vector2(1600, node.rect_global_position.y), origin_pos, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(node, "modulate", node.modulate, Color("#ffffff"), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()

func on_action_selected(player_action, current_node):
	if $UI/EmenyPanel.get_child_count() <= 0:
		return
	var tween = Tween.new()
	self.add_child(tween)
	
	# hide panel and prepare
	for node in $UI/PlayerActionPanel.get_children():
		if node != current_node:
			tween.interpolate_property(node, "modulate", node.modulate, Color("#00ffffff"), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	var enemy_select_action_node = $UI/EmenyPanel.get_children()[randi()%$UI/EmenyPanel.get_child_count()]
	var enemy_action = enemy_select_action_node.data
	for node in $UI/EmenyPanel.get_children():
		if node != enemy_select_action_node:
			tween.interpolate_property(node, "modulate", node.modulate, Color("#00ffffff"), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(current_node, "rect_global_position", current_node.rect_global_position, Vector2(current_node.rect_global_position.x, 360 - current_node.rect_size.y / 2), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(enemy_select_action_node, "rect_global_position", enemy_select_action_node.rect_global_position, Vector2(1280 - current_node.rect_size.x, 360 - current_node.rect_size.y / 2), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(enemy_select_action_node, "rect_size", enemy_select_action_node.rect_size, current_node.rect_size, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	enemy_select_action_node.get_node("RichTextLabel").modulate = Color("#00ffffff")
	enemy_select_action_node.get_node("RichTextLabel").visible = true
	tween.interpolate_property(enemy_select_action_node.get_node("RichTextLabel"), "modulate", Color("#00ffffff"), Color("#ffffff"), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	
	
	var dialogue_node = self.DialogueScene.instance()
	$UI.add_child(dialogue_node)
	dialogue_node.rect_global_position = Vector2(418, 308)
	dialogue_node.start(current_node.data, true)
	yield(dialogue_node, "dialogue_finished")
	
	dialogue_node.rect_global_position = Vector2(613, 208)
	dialogue_node.start(enemy_select_action_node.data, false)
	yield(dialogue_node, "dialogue_finished")
	dialogue_node.queue_free()
	
	
	# start combat
	yield(self.get_tree().create_timer(0.2), "timeout")
	tween.interpolate_property(current_node, "rect_global_position", current_node.rect_global_position, Vector2(1280 + current_node.rect_size.x, current_node.rect_global_position.y), 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.interpolate_property(enemy_select_action_node, "rect_global_position", enemy_select_action_node.rect_global_position, Vector2(-enemy_select_action_node.rect_size.x, enemy_select_action_node.rect_global_position.y), 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	self.get_tree().create_timer(0.4).connect("timeout", self, "show_combat_flash")
	
	var lost_node = null
	# match current term key, add a large number to make it bigger than other term action
	if current_node.data.id == self.current_term_key_action:
		current_node.data.val *= 10
	if enemy_select_action_node.data.id == self.current_term_key_action:
		enemy_select_action_node.data.val *= 10
	
	if current_node.data.id == "ignore":
		enemy_select_action_node.data.val = 0
	if enemy_select_action_node.data.id == "ignore":
		current_node.data.val = 0
		
	if current_node.data.id == "sophistry":
		current_node.data.val = enemy_select_action_node.data.val + 1 if enemy_select_action_node.data.val != 0 else 0
	if enemy_select_action_node.data.id == "sophistry":
		enemy_select_action_node.data.val = current_node.data.val + 1 if current_node.data.val != 0 else 0
	
	if current_node.data.val > enemy_select_action_node.data.val:
		lost_node = $UI/Top/MarginContainer/HBoxContainer/Enemy/HpBar
	elif current_node.data.val < enemy_select_action_node.data.val:
		lost_node = $UI/Top/MarginContainer/HBoxContainer/Player/HpBar
	if lost_node != null:
		self.get_tree().create_timer(0.6).connect("timeout", self, "lost_hp_val", [lost_node])
	yield(tween, "tween_all_completed")
	
	# combat finish and recover
	yield(self.get_tree().create_timer(0.2), "timeout")
	current_node.queue_free()
	enemy_select_action_node.queue_free()
	yield(self.get_tree().create_timer(0.05), "timeout")
	
#	if $UI/PlayerActionPanel.get_child_count() > 0 or $UI/EmenyPanel.get_child_count() > 0:
#		for node in $UI/PlayerActionPanel.get_children():
#			tween.interpolate_property(node, "modulate", node.modulate, Color("#ffffff"), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
#		for node in $UI/EmenyPanel.get_children():
#			tween.interpolate_property(node, "modulate", node.modulate, Color("#ffffff"), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
#		tween.start()
#		yield(tween, "tween_all_completed")
	
	tween.queue_free()
	
	if player_action.id == "think":
		NodeUtils.clear_children($UI/PlayerActionPanel)
		yield(self.get_tree().create_timer(0.05), "timeout")
	if enemy_action.id == "think":
		NodeUtils.clear_children($UI/EmenyPanel)
		yield(self.get_tree().create_timer(0.05), "timeout")
	
	self.next_term()


func show_combat_flash():
	var tween = Tween.new()
	self.add_child(tween)
	
	$SoundEffectPlayer.stream = load("res://assets/musics/sound_effects/hit.wav")
	$SoundEffectPlayer.play()
	
	tween.interpolate_property(self, "modulate", self.modulate, Color(20, 20, 20), 0.1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(self, "modulate", self.modulate, Color("ffffff"), 0.1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	
	tween.queue_free()

func lost_hp_val(node):
	var tween = Tween.new()
	self.add_child(tween)
	var i = 0
	var sprite_node
	if node == $UI/Top/MarginContainer/HBoxContainer/Enemy/HpBar:
		sprite_node = $Ghost
	else:
		sprite_node = $Player
	while i < 2:
		tween.interpolate_property(sprite_node, "modulate", Color("#ffffff"), Color("#ff2c2c"), 0.05, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
		tween.interpolate_property(sprite_node, "modulate", Color("ff2c2c"), Color("#ffffff"), 0.05, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
		i += 1
	
#	node.val = 0.2
	tween.interpolate_property(node, "val", node.val, node.val - 0.2, 0.3,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	
	if (node.val - 0.2) <= 0.4  and $BgmPlayer.pitch_scale != 1.5:
#		$BgmPlayer.pitch_scale = 1.5
		for node in $UI/Bg/BgBlocks.get_children():
#			node.velocity *= 2.5
			tween.interpolate_property(node, "velocity", node.velocity, node.velocity * 2.5, 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property($UI/Bg, "modulate", $UI/Bg.modulate, Color("#ffbbbb"), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property($BgmPlayer, "pitch_scale", $BgmPlayer.pitch_scale, 1.5, 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
#		$UI/Bg.modulate = Color("#ffbbbb")
	
	
	if node.val - 0.2 <= 0:
		$UI/PlayerActionPanel.visible = false
		$UI/EmenyPanel.visible = false
		if sprite_node == $Ghost:
			yield(TweenUtils.audio_fade_out($BgmPlayer, 0.2), "completed")
			$BgmPlayer.stream = load("res://assets/musics/win_bgm.wav")
			$BgmPlayer.pitch_scale = 1.0
			$BgmPlayer.volume_db = 1.0
			$BgmPlayer.play()
		sprite_node.animation = "dead"
		sprite_node.play()
		yield(sprite_node, "animation_finished")
		
		if sprite_node == $Ghost:
			$ResultText.bbcode_text = "[center]YOU WIN![/center]"
		else:
			$ResultText.bbcode_text = "[center]YOU LOSE![/center]"
		
		$ResultText.rect_global_position = Vector2(411, -400)
		tween.interpolate_property($ResultText, "rect_global_position", $ResultText.rect_global_position, Vector2(411, 306), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
		yield(self.get_tree().create_timer(3.0), "timeout")
		if sprite_node == $Ghost:
			SceneChanger.change_scene(win_target_scene)
		else:
#			self.get_tree().reload_current_scene()
			SceneChanger.change_scene(get_tree().current_scene.filename)
	
	tween.queue_free()
	
