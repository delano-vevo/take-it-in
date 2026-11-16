class_name Level
extends Node2D
## Defines base logic for a game level

## Signals
signal level_end ## Emitted when the player exits the level via the door
signal do_thievery ## Emitted when a LootObject triggers the Thievery minigame

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
	player.camera.limit_right = int(level_bounds.x)
	player.camera.limit_bottom = int(level_bounds.y)

## Checks whether a given point is in this level's navigation region
func is_point_in_navmesh(point: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(point, navmesh.navigation_polygon.get_vertices())

## Handle level exit signal from the level's door
func _on_level_end() -> void:
	level_end.emit()

## Handles looted signals from various LootObjects
func _on_object_looted(instance: PackedScene) -> void:
	print("Thievery time! " + str(instance))
	do_thievery.emit()
