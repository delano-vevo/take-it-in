extends Control
## Handles the logic for the level select screen in the game

## Load scenes
## The PackedScene for a single instance of a Level option in the LevelSelect menu
const menu_level_tscn: PackedScene = preload("res://GUI/Screens/LevelSelect/MenuLevel.tscn")

## Constants
## Contains String paths to all Level scenes in the game
const levels: Array[String] = [
	"res://Levels/Level1.tscn",
	"res://Levels/Level2.tscn",
	"res://Levels/Level3.tscn",
]

## Signals
signal level_selected(level: PackedScene) ## Emitted when a MenuLevel is picked and passes the path to the Level back up to Main

## Editor nodes
@export var level_container: HBoxContainer ## The container that holds all the buttons for Levels
@export var level_info: Control ## The outer Control node housing the level overview info
@export var bounty_label: Label ## The Label that displays the bounty for the selected level
@export var security_label: Label ## The Label that displays the security for the selected level
@export var size_label: Label ## The Label that displays size data for the selected level

## Internal variables
@onready var current_level: PackedScene = null ## Maintains a loaded PackedScene resource corresponding to the selected level

## Initialize
func _ready() -> void:
	# Add buttons to the UI for all created levels
	var i: int = 1
	for level in levels:
		print(level)
		var menu_level = menu_level_tscn.instantiate()
		menu_level.level = load(level)
		menu_level.level_path = level
		menu_level.button.text = str(i)
		menu_level.level_selected.connect(_on_level_selected)
		level_container.add_child(menu_level)
		i += 1

## Handles level select signals from individual buttons
func _on_level_selected(level: PackedScene) -> void:
	print("Level selected : " + str(level))
	current_level = level
	# Load the level preview for this level into the preview window
	var selected_level: Level = level.instantiate()
	# Set the level property data in the UI
	bounty_label.set_text("Bounty: $%.2f" % selected_level.bounty)
	security_label.set_text("Security level: " + Global.SECURITY_LEVELS[selected_level.security_level])
	size_label.set_text("Area size: " + Global.LEVEL_SIZES[selected_level.level_size])
	# Show the level property UI
	level_info.visible = true
	# Delete the level with the information extracted
	selected_level.queue_free()

## Handles input from the Begin Level button
func _on_level_select_pressed() -> void:
	if (current_level != null):
		level_selected.emit(current_level)
		queue_free()
