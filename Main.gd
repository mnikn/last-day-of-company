extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var ActionScene = preload("res://ui/action/Action.tscn")


var actions = []
var current_term_key_action = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	self.actions = JsonUtils.load_json_file("res://data/action.json")
	
	self.generate_player_actions()
	self.generate_enemy_actions()
	
	current_term_key_action = "reason"
	$UI/TermKeyPanel/Label.text = I18n.translate(ArrayUtils.find(actions, { "id": self.current_term_key_action }).name)


func generate_player_actions():
	NodeUtils.clear_children($UI/PlayerActionPanel)
	var player_action = []
	var normal_actions = ArrayUtils.map(ArrayUtils.filter(actions, { "type": "normal" }), "id")
	var special_actions = ArrayUtils.map(ArrayUtils.filter(actions, { "type": "special" }), "id")
	
	randomize()
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
		node.player = true
		node.data = data
		$UI/PlayerActionPanel.add_child(node)

func generate_enemy_actions():
	NodeUtils.clear_children($UI/EmenyPanel)
	var player_action = []
	var normal_actions = ArrayUtils.map(ArrayUtils.filter(actions, { "type": "normal" }), "id")
	var special_actions = ArrayUtils.map(ArrayUtils.filter(actions, { "type": "special" }), "id")
	
	randomize()
	var r1 = normal_actions[randi() % len(normal_actions)]
	var r2 = normal_actions[randi() % len(normal_actions)]
	
	player_action.append_array(normal_actions)
	player_action.insert(player_action.find(r1), r1)
	player_action.insert(player_action.find(r2), r2)
	
	player_action.push_back(special_actions[randi() % len(special_actions)])
	
	var val = 10
	for action in player_action:
		var node = self.ActionScene.instance()
		var data = ArrayUtils.find(actions, { "id": action })
		if data.type == "normal":
			val = max(randi() % val + 1, 3)
			if $UI/PlayerActionPanel.get_child_count() == 0:
				val = max(val, 6)
			data.val = val
		node.player = false
		node.data = data
		$UI/EmenyPanel.add_child(node)
