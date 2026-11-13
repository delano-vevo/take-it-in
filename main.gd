class_name Main
extends Node2D
## Responsible for scene handling and controlling the gameplay "flow"

## Editor nodes
@export var ui_layer: CanvasLayer ## The layer responsible for rendering fixed UI elements over the game

## Gameplay variables
@export var current_level: Node2D ## Exposed to the editor so that levels can be hotswapped for testing
@onready var money: float = 0.0 ## Tracks the amount of money the player has earned this level

## Initialize game
func _ready() -> void:
	# Set the window clear color to match palette
	RenderingServer.set_default_clear_color(Color("a75252"))

## Signal handler for when money is obtained
func _on_money_get(amount: float) -> void:
	money += amount
	print("Total money: " + str(money))
	# Update the UI element
