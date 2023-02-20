extends Node

const CONFIG_PATH = "res://Saved/config.cfg"
const STATS_PATH = "res://Saved/stats.cfg"

var config_file = ConfigFile.new()
onready var settings = {
	"audio": {
		"music_level": Global.music_level,
		"sfx_level": Global.sfx_level
	},
	"game": {
		"difficulty": Global.difficulty
	}
}
var stats_file = ConfigFile.new()
var stats

func save_settings():
	settings = {
		"audio": {
			"music_level": Global.music_level,
			"sfx_level": Global.sfx_level
		},
		"game": {
			"difficulty": Global.difficulty
		}
	}
	for section in settings.keys():
		for key in settings[section].keys():
			var val = settings[section][key]
			config_file.set_value(section, key, val)
			print("%s %s" % [key, val])
	config_file.save(CONFIG_PATH)

func load_settings():
	var error = config_file.load(CONFIG_PATH)
	if error != OK:
		print("Error loading settings")
		return []
	else:
		var values = []
		for section in settings.keys():
			for key in settings[section].keys():
				var val = settings[section][key]
				values.append(config_file.get_value(section, key, val))
				print("%s %s" % [key, val])
		return values

func update_stats(diff):
	stats = get_game_stats()
	var error = stats_file.load(STATS_PATH)
	if error != OK:
		print("Error loading stats")
	else:
		for key in stats[diff].keys():
			var val = stats[diff][key]
			var saved_val = stats_file.get_value(diff, key, val)
			print(val, " ", saved_val)
			if val > saved_val:
				stats_file.set_value(diff, key, val)
			print("%s %s" % [key, val])
	stats_file.save(STATS_PATH)

func get_game_stats():
	var s = {
		"1": {
			"longest_survival": Global.time_alive,
			"highest_wave_reached": Global.current_wave,
			"most_enemies_killed": Global.enemies_killed
		},
		"2": {
			"longest_survival": Global.time_alive,
			"highest_wave_reached": Global.current_wave,
			"most_enemies_killed": Global.enemies_killed
		},
		"3": {
			"longest_survival": Global.time_alive,
			"highest_wave_reached": Global.current_wave,
			"most_enemies_killed": Global.enemies_killed
		}
	}
	return s
