class_name Main
extends Node2D
## Responsible for scene handling and controlling the gameplay "flow"

## Resource loads
const player_tscn: PackedScene = preload("res://Entities/Player/Player.tscn")
const thievery_tscn: PackedScene = preload("res://Thievery/Thievery.tscn")
const game_over_tscn: PackedScene = preload("res://GUI/Screens/GameOverScreen.tscn")
const bounty_failed_tscn: PackedScene = preload("res://GUI/Screens/BountyFailedScreen.tscn")
const level_end_tscn: PackedScene = preload("res://GUI/Screens/LevelEndScreen.tscn")
const sirens_fx: PackedScene = preload("res://VFX/SirenFlash.tscn")

## Constants
## Contains an array of String paths to all levels
const levels: Array[String] = [
	"res://Levels/Level1.tscn"
]

## Editor nodes
@export var ui_layer: CanvasLayer ## The layer responsible for rendering fixed UI elements over the game
@export var thievery_layer: CanvasLayer ## The layer responsible for rendering the Thievery minigame
@export var gameplay_ui: Control ## The Control node that houses the gameplay UI elements
@export var game_over_timer: Timer ## A timer that provides some offset between a game over trigger and the actual game over screen to make the flow less jarring
@export var level_timer: Timer ## A Timer that controls the level timeout game over state
@export var level_select_ui: Control ## The Control node housing the level select menu; exposed to the editor for setup
@export var soundtrack: AudioStreamPlayer ## The audio stream that handles the soundtrack

## Gameplay variables
@export var current_level: Node2D ## Exposed to the editor so that levels can be hotswapped for testing
@onready var money: float = 0.0 ## Tracks the amount of money the player has earned this level

## Initialize game
func _ready() -> void:
	get_tree().paused = true
	# Set the window clear color to match palette
	RenderingServer.set_default_clear_color(Color("a75252"))

## Game loop
func _process(delta: float) -> void:
	# Update the timer UI
	if (current_level != null): # Don't do this when a level isn't loaded
		gameplay_ui.timer_ui.set_time(level_timer.time_left)
	# Music toggle
	if (Input.is_action_just_pressed("toggle_music")):
		AudioServer.set_bus_mute(2,!AudioServer.is_bus_mute(2))

## Starts a Level based on the provided path
func start_level(level_tscn: PackedScene) -> void:
	# Remove the current level, if necessary
	if (current_level != null):
		current_level.queue_free()
	# Add the new level to the scene tree
	current_level = level_tscn.instantiate()
	add_child(current_level)
	# Connect signals
	current_level.level_end.connect(_on_level_end)
	current_level.do_thievery.connect(do_thievery)
	current_level.player.game_over.connect(_on_game_over)
	current_level.player_spotted.connect(_on_player_spotted)
	current_level.player_safe.connect(_on_player_safe)
	# Set up the timer
	level_timer.start(current_level.level_time)
	# Set up the UI elements
	gameplay_ui.visible = true
	gameplay_ui.money_ui.set_money(0, current_level.bounty)
	# Fade in the bassline
	soundtrack.fade_in_track(Enum.AudioTracks.BASSLINE)
	# Unpause the game
	get_tree().paused = false
	# Pass player reference to all enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.player = current_level.player

## Triggers a Thievery event
func do_thievery() -> void:
	var thievery = thievery_tscn.instantiate()
	thievery_layer.add_child(thievery)
	thievery.thievery_done.connect(_on_thievery_done)
	thievery.get_money.connect(_on_money_get)
	remove_child(current_level) # Remove the current level from the scene tree, but keep it loaded in memory
## Triggered on the end of a Thievery event
func _on_thievery_done() -> void:
	add_child(current_level) # Return the level from memory to the scene tree

## Signal handler for when money is obtained
func _on_money_get(amount: float) -> void:
	money += amount
	# Update the UI element
	gameplay_ui.money_ui.set_money(money, current_level.bounty)

## Handler for a game over state caused by the level timer expiring
func _on_out_of_time() -> void:
	current_level.player.state_machine.set_state(current_level.player.state_machine.caught_state)
	_on_game_over() # For now just pass it through to the generic game over handler but some specific FX for this would be cool eventually

## Signal handler for game over state
func _on_game_over() -> void:
	if (game_over_timer.is_stopped()): # Avoid multiple concurrent game overs
		# Start the countdown and add some siren FX
		game_over_timer.start()
		var sirens = sirens_fx.instantiate()
		ui_layer.add_child(sirens)
		# Kill the thievery instance, if necessary
		if (thievery_layer.get_child(0) != null):
			thievery_layer.get_child(0).queue_free()
			_on_thievery_done()
		# Tone down the music
		soundtrack.fade_out_track(Enum.AudioTracks.MELODY)
		soundtrack.fade_out_track(Enum.AudioTracks.DRUMLINE)

## Process the actual game over screen after timer delay
func _on_game_over_timer_timeout() -> void:
	get_tree().paused = true
	var game_over = game_over_tscn.instantiate()
	game_over.restart_game.connect(_on_restart)
	ui_layer.add_child(game_over)

## Called when a player hits Try again from the game over screen
func _on_restart() -> void:
	get_tree().reload_current_scene()

## Called when the level signals the player has taken the exit door to leave
func _on_level_end() -> void:
	get_tree().paused = true
	# Check to see if the bounty was met
	if (money >= current_level.bounty):
		# Set the flag for level cleared in Global
		Global.levels_cleared[current_level.level_path] = true
		# Put up the end-of-level success screen
		var level_end = level_end_tscn.instantiate()
		level_end.restart_game.connect(_on_restart)
		# Determine the player's ranking based on their surplus cash:
		var extra_money: float = money - current_level.bounty
		level_end.do_rank(extra_money)
		ui_layer.add_child(level_end)
	else:
		var bounty_failed = bounty_failed_tscn.instantiate()
		bounty_failed.restart_game.connect(_on_restart)
		ui_layer.add_child(bounty_failed)

## Signalled when the player is spotted and pursued by a guard
func _on_player_spotted() -> void:
	soundtrack.fade_in_track(Enum.AudioTracks.MELODY)

## Signalled when the player effectively evades their pursuers
func _on_player_safe() -> void:
	soundtrack.fade_out_track(Enum.AudioTracks.MELODY)
