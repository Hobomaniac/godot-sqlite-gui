extends Control

var flash_card: Button
var word_database: SQLite
var cards_array: Array
var current_card_index: int


# Called when the node enters the scene tree for the first time.
func _ready():
	word_database = InitDatabase.word_data
	var check_words_exist: bool = word_database.query("SELECT * FROM words;")
	if check_words_exist:
		cards_array = word_database.query_result
	else:
		print("No words exists in database.")
		cards_array = []
	flash_card = $MarginContainer/VBoxContainer/FlashCardButton
	
	current_card_index = 0
	if cards_array.size() != 0:
		flash_card.text = cards_array[current_card_index]["main_word"]

func update_card(state: String):
	if state == "main_word":
		flash_card.text = cards_array[current_card_index]["main_word"]
	elif state == "trans_word":
		flash_card.text = cards_array[current_card_index]["trans_word"]
	else:
		print(" That state does not exist!")

func _on_prev_button_button_up():
	if cards_array.size() == 0:
		return
		
	if current_card_index > 0:
		current_card_index -= 1
	update_card("main_word")


func _on_next_button_button_up():
	if cards_array.size() == 0:
		return
		
	if current_card_index < cards_array.size() - 1:
		current_card_index += 1
	update_card("main_word")


func _on_flash_card_button_button_up():
	if cards_array.size() == 0:
		return
		
	if flash_card.text == cards_array[current_card_index]["main_word"]:
		flash_card.text = cards_array[current_card_index]["trans_word"]
	elif flash_card.text == cards_array[current_card_index]["trans_word"]:
		flash_card.text = cards_array[current_card_index]["main_word"]
	else:
		print(" Text does not equal either the main or translation words")
		flash_card.text = cards_array[current_card_index]["main_word"]


func _on_edit_cards_button_button_up():
	get_tree().change_scene_to_file("res://scenes/database_controller.tscn")
