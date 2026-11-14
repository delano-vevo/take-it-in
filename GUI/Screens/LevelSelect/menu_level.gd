extends ColorRect
## Defines a single Level option in the LevelSelect screen

## Signals
signal level_selected(level: PackedScene) ## Emitted when this is clicked; passes the path to the Level scene to the receiver

## Editor nodes
@export var button: Button ## The Button that indicates this level has been selected

## Internal variables
@onready var level: PackedScene ## The PackedScene resource for the Level corresponding to this option

## Handle button press
func _on_select_button_pressed() -> void:
	level_selected.emit(level)
