extends Control

var word_database: SQLite
var main_word_text: LineEdit
var trans_word_text: LineEdit

func _ready():
	word_database = InitDatabase.word_data
	main_word_text = $MarginContainer/VBoxContainer/HBoxContainer/MainWordText
	trans_word_text = $MarginContainer/VBoxContainer/HBoxContainer2/TransWordText
	update_screen()


func update_screen():
	var check = word_database.query("SELECT main_word FROM words;")
	
	if check:
		for node in get_tree().get_nodes_in_group("invisible_buttons"):
			node.visible = true
	else:
		for node in get_tree().get_nodes_in_group("invisible_buttons"):
			node.visible = false

func _on_create_table_button_button_up():
	var table_name = "words"
	var table_dict: Dictionary
	table_dict["id"] = {"data_type": "int", "primary_key": true, "auto_increment": true}
	table_dict["main_word"] = {"data_type": "text", "not_null": true}
	table_dict["trans_word"] = {"data_type": "text", "not_null": true}
	var check = word_database.create_table("words", table_dict)
	if check:
		print("Created table 'words'")
		update_screen()
	else:
		print("Could not create table 'words'")


func _on_delete_table_button_button_up():
	var check = word_database.drop_table("words")
	if check:
		print("Dropped table 'words'")
		update_screen()
	else:
		print("Could not drop table 'words'")


func _on_add_row_button_button_up():
	#var word_to_check = "\"" + main_word_text.text + "\""
	var word_to_check = main_word_text.text
	word_database.query("SELECT * FROM words WHERE main_word='" + word_to_check.replace("'", "''") + "';")
	var result = word_database.query_result
	
	if result.size() != 0:
		print(" " + word_to_check + " already exists within database.")
		return
		
	var check_insert = word_database.insert_row("words", {"main_word": word_to_check, "trans_word": trans_word_text.text})
	
	if check_insert:
		print(" " + word_to_check + ": " + trans_word_text.text + " was added to the database.")
	else:
		print(" " + word_to_check + " was not added to the database.")


func _on_delete_row_button_button_up():
	var word_to_check = main_word_text.text
	word_database.query("SELECT * FROM words WHERE main_word='" + word_to_check.replace("'", "''") + "';")
	var result = word_database.query_result
	
	if result.size() == 0:
		print(" " + word_to_check + "does not exist in the database.")
		return
		
	var check_delete = word_database.delete_rows("words", "main_word='" + word_to_check.replace("'", "''") + "'")
	
	if check_delete:
		print(" " + word_to_check + " was deleted from database.")
	else:
		print(" " + word_to_check + " was not deleted from the database.")


func _on_edit_trans_word_button_button_up():
	if trans_word_text.text == "":
		print("Empty LineEdit")
		return
	
	var word_to_check = main_word_text.text
	word_database.query("SELECT * FROM words WHERE main_word='" + word_to_check.replace("'", "''") + "';")
	var result = word_database.query_result
	
	if result.size() == 0:
		print(" Did not find " + word_to_check)
		return
	
	var row_data = {"trans_word": trans_word_text.text}
	var check_update = word_database.update_rows("words", "main_word='" + word_to_check.replace("'", "''") + "'", row_data)
	
	if check_update:
		print(" Successfully updated: " + word_to_check)
	else:
		print(" Failed to update: " + word_to_check)


func _on_go_back_button_button_up():
	get_tree().change_scene_to_file("res://scenes/flash_card_scene.tscn")
