extends NinePatchRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var velocity = 1000

func _process(delta):
	var screen_size = OS.get_screen_size()
	if self.rect_global_position.x >= screen_size.x:
		self.rect_global_position.x = -self.rect_size.x + randi() % 20
		return
		
	var coff = (screen_size.x - self.rect_global_position.x) / screen_size.x
	coff = 1 + abs(1 - coff)
	self.rect_global_position.x += velocity * delta * coff
