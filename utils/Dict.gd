extends Node
class_name DictUtils


static func get_value(obj, property: String, default_value = null):
	var arr = property.split(".")
	if len(arr) <= 0:
		return null
	return _do_get_value(obj, arr, default_value)

static func _do_get_value(obj, property_arr: PoolStringArray, default_value):
	if len(property_arr) <= 0 or obj == null:
		return default_value
	var tmp = default_value
	if obj.has(property_arr[0]):
		tmp =  obj[property_arr[0]]
	if len(property_arr) == 1:
		return tmp
	
	var sub_arr = []
	for i in range(1, len(property_arr)):
		sub_arr.push_back(property_arr[i])
	return _do_get_value(tmp, sub_arr, default_value)

static func assign(obj: Dictionary, obj2: Dictionary) -> Dictionary:
	var res = {}
	for key in obj.keys():
		res[key] = obj[key]
	for key in obj2.keys():
		res[key] = obj2[key]
	return res

static func copy(obj: Dictionary) -> Dictionary:
	var res = {}
	for key in obj.keys():
		res[key] = _do_copy(obj[key])
	return res

static func _do_copy(obj):
	if obj is Dictionary:
		var res = {}
		for key in obj.keys():
			res[key] = _do_copy(obj[key])
		return res
	elif obj is Array:
		var res = []
		for item in obj:
			res.push_back(_do_copy(item))
		return res
	else:
		return obj
