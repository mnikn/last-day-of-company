extends ColorRect
tool

export (float) var val = 1.0

func _process(delta):
	self.material.set_shader_param("resolution", self.rect_size)
	self.material.set_shader_param("val", val)
