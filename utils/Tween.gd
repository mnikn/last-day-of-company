extends Node
class_name TweenUtils

static func audio_fade_out(stream_player, duration = 2):
	var tween = Tween.new()
	stream_player.add_child(tween)
	var origin_volume = stream_player.volume_db
	tween.interpolate_property(stream_player, "volume_db", origin_volume, -100, duration, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()

static func audio_fade_in(stream_player, duration = 2):
	var tween = Tween.new()
	stream_player.add_child(tween)
	var origin_volume = stream_player.volume_db
	tween.interpolate_property(stream_player, "volume_db", -100, origin_volume, duration, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()

static func visible_fade_out(node, duration = 2):
	var tween = Tween.new()
	node.add_child(tween)
	tween.interpolate_property(node, "modulate", node.modulate, Color(0,0,0,0), duration, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()

static func visible_fade_in(node, duration = 2):
	var tween = Tween.new()
	node.add_child(tween)
	tween.interpolate_property(node, "modulate", node.modulate, Color("#ffffff"), duration, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()
