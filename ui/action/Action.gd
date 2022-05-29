extends Panel
signal clicked()

export (bool) var player = true

var data

var PlayerNormalMaterial = preload("./PlayerNormal.tres")
var PlayerSpecialMaterial = preload("./PlayerSpecial.tres")
var EnemyNormalMaterial = preload("./EnemyNormal.tres")
var EnemySpecialMaterial = preload("./EnemySpecial.tres")
var enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel.text = I18n.translate(data.name)
	if self.data.type == "normal":
		$RichTextLabel.text = I18n.translate(data.name) + " - "  + String(data.val)
	if player:
		self.rect_min_size = Vector2(280, 64)
		self.rect_size = self.rect_min_size
		$RichTextLabel.visible = true
		if data.id in ["reason", "empathy", "threaten"]:
			self.material = self.PlayerNormalMaterial
			$RichTextLabel.add_color_override("font_color", Color("efb775"))
		else:
			self.material = self.PlayerSpecialMaterial
			$RichTextLabel.add_color_override("font_color", Color("6b301c"))
	else:
		self.rect_min_size = Vector2(140, 32)
		self.rect_size = self.rect_min_size
		self.mouse_default_cursor_shape = Control.CURSOR_ARROW
		$RichTextLabel.visible = false
		if data.id in ["reason", "empathy", "threaten"]:
			self.material = self.EnemyNormalMaterial
			$RichTextLabel.add_color_override("font_color", Color("efb775"))
		else:
			self.material = self.EnemySpecialMaterial
			$RichTextLabel.add_color_override("font_color", Color("6b301c"))
	self.material = self.material.duplicate(true)


func _on_Action_mouse_entered():
	if self.player:
		if data.id in ["reason", "empathy", "threaten"]:
			self.material.set_shader_param("base_col", Color("6b301c").lightened(0.2))
		else:
			self.material.set_shader_param("base_col", Color("efb775").lightened(0.5))


func _on_Action_mouse_exited():
	if self.player:
		if data.id in ["reason", "empathy", "threaten"]:
			self.material.set_shader_param("base_col", Color("6b301c"))
		else:
			self.material.set_shader_param("base_col", Color("efb775"))

func _on_Action_gui_input(event):
	if not self.player:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and self.enabled:
			self.enabled = false
			self.emit_signal("clicked")
			print_debug("action triggered")
