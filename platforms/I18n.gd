extends Node

const LANG_EN = "en"
const LANG_ZH = "zh"

var current_lang = LANG_EN if OS.get_locale_language() != "zh" else LANG_ZH
var lang_data = {}

func _ready():
	self.set_lang(LANG_ZH)

func set_lang(lang: String):
	if lang == LANG_ZH:
		self.lang_data = JsonUtils.load_json_file("res://data/i18n/zh.json")
	else:
		self.lang_data = JsonUtils.load_json_file("res://data/i18n/en.json")
	self.current_lang = lang

func t(key: String) -> String:
	if not self.lang_data.has(key):
		return key
	return self.lang_data[key]

func translate(obj: Dictionary) -> String:
	if obj.has(current_lang):
		return obj[current_lang]
	return ""
