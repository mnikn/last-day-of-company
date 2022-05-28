extends ColorRect
tool

func _process(delta):
	self.material.set_shader_param("resolution", self.rect_size)
