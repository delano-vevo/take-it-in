class_name Level
extends Node2D
## Defines base logic for a game level

## Signals
signal level_end ## Emitted when the player exits the level via the door
signal do_thievery ## Emitted when a LootObject triggers the Thievery minigame
signal player_spotted ## Emitted when the player is spotted by a guard
signal player_safe ## Emitted when the player successfully evades all guards pursuing them

## Editor nodes
@export var navmesh: NavigationRegion2D ## The level's navigation mesh
@export var player: Player ## The Player controller instance in the level

## Gameplay variables
@export var level_bounds: Vector2 = Vector2(320,240) ## The size of the level in pixels; defaults to screen size
@export var bounty: float = 0.0 ## The amount of money the player needs to make this level to avoid a game over
@export var level_time: float = 60.0 ## The amount of time, in seconds, the player gets before the level times out
@export var security_level: Enum.SecurityTiers = Enum.SecurityTiers.LOW ## The amount of security the player will encounter in this level
@export var level_size: Enum.LevelSize = Enum.LevelSize.SMALL ## The size of the level for display in the level select screen
@export var level_path: String ## Maintain a string with a reference to the path to this level in the filesystem

## Initialize
func _ready() -> void:
	# Set the camera bounds
	player.camera.limit_right = int(level_bounds.x)
	player.camera.limit_bottom = int(level_bounds.y)
	# Hook up signals from guards
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.player_spotted.connect(_on_player_spotted)
		enemy.player_lost.connect(_on_player_lost)

## Checks whether a given point is in this level's navigation region
func is_point_in_navmesh(point: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(point, navmesh.navigation_polygon.get_vertices())

## Handle level exit signal from the level's door
func _on_level_end() -> void:
	level_end.emit()

## Handles looted signals from various LootObjects
func _on_object_looted() -> void:
	do_thievery.emit()

## Handles player_spotted signals from individual guards
func _on_player_spotted() -> void:
	player_spotted.emit()

## Handles lost_player signals from individual guards
func _on_player_lost(which_enemy: Enemy) -> void:
	print("Lost the player...")
	var player_lost: bool = true
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if (enemy.state_machine.current_state == enemy.state_machine.chase_state and enemy != which_enemy):
			print("Enemy: " + str(enemy) + " is in the chase state: " + str(enemy.state_machine.current_state))
			player_lost = false
	if (player_lost):
		print("The player is safe!")
		player_safe.emit()
