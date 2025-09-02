extends Control

@onready var text_edit: TextEdit = $VBoxContainer/HBoxContainer/TextEdit
@onready var text_result: RichTextLabel = $VBoxContainer/HBoxContainer/RichTextLabel
@onready var settings_button: Button = $VBoxContainer/HBoxContainer2/SettingsButton
@onready var settings_window: Window = $VBoxContainer/HBoxContainer2/SettingsButton/SettingsWindow
@onready var txtsize: TextEdit = $VBoxContainer/HBoxContainer2/SettingsButton/SettingsWindow/VBoxContainer/VBoxContainer/HBoxContainer/TXTSIZE
@onready var uitxtsize: TextEdit = $VBoxContainer/HBoxContainer2/SettingsButton/SettingsWindow/VBoxContainer/VBoxContainer/HBoxContainer2/UITXTSIZE
const MAIN_DEV_THEME = preload("res://main_dev_theme.tres")

var live_text: String
var process_text: Array
var result_text: String
var title_size = 72
var paragraph_size = 160

var render_text_size = 16
var ui_text_size = 16
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_window.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_text_edit_text_changed() -> void:
	
	live_text = text_edit.text
	process_text = live_text.split(Tokens.DELIMITER,false)
	
	print(process_text)
	result_text = ""
	
	
	for element in process_text:
		
		element = clean_string(element)
		print(element)
		
		if element.begins_with(Tokens.PRELIMITER):
			element = remove_prefix(element,Tokens.PRELIMITER)
			if element.begins_with(Tokens.settings["SETTING_TITLE_SIZE"]):
				element = remove_prefix(element,Tokens.settings["SETTING_TITLE_SIZE"])
				if element.begins_with("\n"):
					element = remove_prefix(element,"\n")
			
			title_size = int(element)
					
			if element.begins_with(Tokens.settings["SETTING_PARAGRAPH_SIZE"]):
				element = remove_prefix(element,Tokens.settings["SETTING_PARAGRAPH_SIZE"])
				if element.begins_with("\n"):
					element = remove_prefix(element,"\n")
			paragraph_size = int(element)
				
				#print(title_size)
		elif element.begins_with(Tokens.settings["SETTING_PARAGRAPH_SIZE"]):
			element = remove_prefix(element,Tokens.settings["SETTING_PARAGRAPH_SIZE"])
			if element.begins_with("\n"):
				element = remove_prefix(element,"\n")
				paragraph_size = int(element)
				
				
				
				
			
		
		if element.begins_with(Tokens.tokens["TOKEN_TITLE"]):
			var title = "[font_size="+str(title_size)+"]"+remove_prefix(element,Tokens.tokens["TOKEN_TITLE"])+"[/font_size]\n\n"
			result_text += title
		elif element.begins_with(Tokens.tokens["TOKEN_PARAGRAPH"]):

			var paragraph = "[p]"+"[font_size="+str(paragraph_size)+"]"+remove_prefix(element,Tokens.tokens["TOKEN_PARAGRAPH"])+"[/font_size]"+"[/p]\n"
			result_text += paragraph
		elif element.begins_with(Tokens.tokens["TOKEN_COMMENT"]):
			pass
		else:
			print("Unexpected string, entered text will be ignored untill next delimiter")
		
		print(result_text)
	
	text_result.clear()
	text_result.text = ""
	text_result.append_text(result_text)
	
func remove_prefix(text, prefix):
	if text.begins_with(prefix):
		return text.substr(prefix.length(), text.length() - prefix.length())
	return text

func remove_suffix(text, suffix):
	if text.ends_with(suffix):
		return text.substr(0, text.length() - suffix.length())
	return text

func clean_string(string):
	string = string.strip_edges()
	if string.begins_with("\n"):
		string = remove_prefix(string,"\n")
	return string


func _on_settings_button_pressed() -> void:
	settings_window.visible = not settings_window.visible


func _on_settings_window_close_requested() -> void:
	settings_window.hide()


func _on_size_settings_button_pressed() -> void:
	text_edit.add_theme_font_size_override("font_size", int(txtsize.text))


func _on_ui_size_settings_button_pressed() -> void:
	MAIN_DEV_THEME.set_font_size("font_size","Node",int(uitxtsize.text))
