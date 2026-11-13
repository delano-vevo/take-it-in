class_name Main
extends Node2D
## Responsible for scene handling and controlling the gameplay "flow"

## Resource loads
const thievery_tscn: PackedScene = preload("res://Thievery/Thievery.tscn")

## Editor nodes
@export var ui_layer: CanvasLayer ## The layer responsible for rendering fixed UI elements over the game
@export var thievery_layer: CanvasLayer ## The layer responsible for rendering the Thievery minigame
@export var timer_ui: Control ## The UI node responsible for displaying the level timer
@export var money_ui: Control ## The UI node responsible for displaying the player's current money
@export var level_timer: Timer ## The actual Timer node responsible for the level time
@export var player: Entity ## The player

## Gameplay variables
@export var current_level: Node2D ## Exposed to the editor so that levels can be hotswapped for testing
@onready var money: float = 0.0 ## Tracks the amount of money the player has earned this level

## Initialize game
func _ready() -> void:
	# Set the window clear color to match palette
	RenderingServer.set_default_clear_color(Color("a75252"))
	# Initialize UI elements
	money_ui.set_money(0)

## Game loop
func _process(delta: float) -> void:
	# Update the timer UI
	timer_ui.set_time(level_timer.time_left)
	# Debug inputs
	if (Input.is_action_just_pressed("debug_1")):
		do_thievery()

## Triggers a Thievery event
func do_thievery() -> void:
	print("Initiating diabolical thievery!")
	var thievery = thievery_tscn.instantiate()
	thievery_layer.add_child(thievery)
	thievery.thievery_done.connect(_on_thievery_done)
	thievery.get_money.connect(_on_money_get)
	remove_child(current_level) # Remove the current level from the scene tree, but keep it loaded in memory
	remove_child(player)

func _on_thievery_done() -> void:
	add_child(current_level) # Return the level from memory to the scene tree
	add_child(player)

## Signal handler for when money is obtained
func _on_money_get(amount: float) -> void:
	money += amount
	print("Total money: " + str(money))
	# Update the UI element
	money_ui.set_money(money)
