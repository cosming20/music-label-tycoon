@tool
extends EditorScript

func _run() -> void:
	var config := ConfigFile.new()
	config.load("res://export_presets.cfg")

	# Find next preset index
	var idx := 0
	while config.has_section("preset.%d" % idx):
		idx += 1

	var section := "preset.%d" % idx
	var options := "%s.options" % section

	config.set_value(section, "name", "Web")
	config.set_value(section, "platform", "Web")
	config.set_value(section, "runnable", true)
	config.set_value(section, "dedicated_server", false)
	config.set_value(section, "custom_features", "")
	config.set_value(section, "export_filter", "all_resources")
	config.set_value(section, "include_filter", "")
	config.set_value(section, "exclude_filter", "")
	config.set_value(section, "export_path", "build/web/index.html")
	config.set_value(section, "encryption_include_filters", "")
	config.set_value(section, "encryption_exclude_filters", "")
	config.set_value(section, "encrypt_pck", false)
	config.set_value(section, "encrypt_directory", false)

	config.set_value(options, "custom_template/debug", "")
	config.set_value(options, "custom_template/release", "")
	config.set_value(options, "variant/extensions_support", false)
	config.set_value(options, "vram_texture_compression/for_desktop", false)
	config.set_value(options, "vram_texture_compression/for_mobile", true)
	config.set_value(options, "html/export_icon", true)
	config.set_value(options, "html/custom_html_shell", "")
	config.set_value(options, "html/head_include", "")
	config.set_value(options, "html/canvas_resize_policy", 2)
	config.set_value(options, "html/focus_canvas_on_start", true)
	config.set_value(options, "html/experimental_virtual_keyboard", true)
	config.set_value(options, "progressive_web_app/enabled", false)

	config.save("res://export_presets.cfg")
	print("Web export preset created at index %d" % idx)
