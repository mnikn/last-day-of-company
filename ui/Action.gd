extends Panel
tool

export (bool) var special = false
export (bool) var flip = false
export (bool) var font_visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.material = self.material.duplicate(true)
	if special:
#		$RichTextLabel.add_color_override("default_color", Color("6b301c"))
		$RichTextLabel.add_color_override("font_color", Color("6b301c"))
		self.material.set_shader_param("base_col", Color("efb775"))
	else:
#		$RichTextLabel.add_color_override("default_color", Color("efb775"))
		$RichTextLabel.add_color_override("font_color", Color("efb775"))
		self.material.set_shader_param("base_col", Color("6b301c"))

	if flip:
		self.material.set_shader_param("flip", true)
	
#	if self.rect_size.x <= 200:
#		$RichTextLabel.get_font("font").size = 24
	if not font_visible:
		$RichTextLabel.visible = false
#	print_debug($RichTextLabel.get_font("normal_font").size)
