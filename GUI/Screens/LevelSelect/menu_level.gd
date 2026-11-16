extends ColorRect
## Defines a single Level option in the LevelSelect screen

## Signals
signal level_selected(level: PackedScene) ## Emitted when this is clicked; passes the path to the Level scene to the receiver

## Editor nodes
@export var button: Button ## The Button that indicates this level has been selected
@export var cleared_checkmark: TextureRect ## The texture that shows if this level has been completed

## Internal variables
@onready var level: PackedScene ## The PackedScene resource for the Level corresponding to this option
@onready var level_path: String ## The String containing the path in the file structure to the level

## Initializer
func _ready() -> void:
	if (Global.levels_cleared[level_path]):
		cleared_checkmark.visible = true

## Handle button press
func _on_select_button_pressed() -> void:
	level_selected.emit(level)
