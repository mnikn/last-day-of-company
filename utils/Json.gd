extends Node
class_name JsonUtils

static func load_json_file(path: String) -> Dictionary:
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	var res = JSON.parse(content).result
	file.close()
	return res

static func write_json_file(path: String, data: Dictionary):
	var file = File.new()
	file.open(path, File.WRITE)
	var content = JSON.print(data, "  ")
	file.store_string(content)
	file.close()
	return content

static func exits_json_file(path: String):
	var file = File.new()
	return file.file_exists(path)
