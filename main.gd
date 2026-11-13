class_name Main
extends Node2D
## Responsible for scene handling and controlling the gameplay "flow"

## Gameplay variables
@export var current_level: Node2D ## Exposed to the editor so that levels can be hotswapped for testing

## Initialize game
func _ready() -> void:
	# Set the window clear color to match palette
	RenderingServer.set_default_clear_color(Color("a75252"))
