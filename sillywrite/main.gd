extends Control

@onready var text_edit: TextEdit = $VBoxContainer/HBoxContainer/TextEdit
@onready var text_result: RichTextLabel = $VBoxContainer/HBoxContainer/RichTextLabel

var live_text: String
var process_text: Array
var result_text: String
var title_size = 72
var paragraph_size = 16
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
				#print(title_size)
				
			
		
		if element.begins_with(Tokens.tokens["TOKEN_TITLE"]):
			var title = "[font_size="+str(title_size)+"]"+remove_prefix(element,Tokens.tokens["TOKEN_TITLE"])+"[/font_size]\n\n"
			result_text += title
		elif element.begins_with(Tokens.tokens["TOKEN_PARAGRAPH"]):
			var paragraph = "[p]"+remove_prefix(element,Tokens.tokens["TOKEN_PARAGRAPH"])+"[/p]\n"
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
