extends Node

var word_data: SQLite

# Called when the node enters the scene tree for the first time.
func _ready():
	#open database
	word_data = SQLite.new()
	word_data.path = "user://data/data.db"
	while true:
		if word_data.open_db():
			print("Opened database")
			break
		word_data.close_db()
		if !DirAccess.dir_exists_absolute("user://data/"):
			DirAccess.make_dir_absolute("user://data/")
		DirAccess.copy_absolute("res://data/data.db", 'user://data/data.db')
		print(" Copying files from res:// to user://")
