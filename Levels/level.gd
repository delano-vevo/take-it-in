class_name Level
extends Node2D
## Defines base logic for a game level

## Signals
signal out_of_time ## Emitted when the level timer runs out
signal level_end ## Emitted when the player exits the level via the door
signal do_thievery ## Emitted when a LootObject triggers the Thievery minigame

## Editor nodes
@export var navmesh: NavigationRegion2D ## The level's navigation mesh
@export var level_timer: Timer ## The Timer responsible for counting down this level's time remaining
@export var player: Player ## The Player controller instance in the level

## Gameplay variables
@export var bounty: float = 0.0 ## The amount of money the player needs to make this level to avoid a game over

## Checks whether a given point is in this level's navigation region
func is_point_in_navmesh(point: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(point, navmesh.navigation_polygon.get_vertices())

## Out of time - emit signal
func _on_level_timer_timeout() -> void:
	out_of_time.emit()

## Handle level exit signal from the level's door
func _on_level_end() -> void:
	level_end.emit()

## Handles looted signals from various LootObjects
func _on_object_looted() -> void:
	do_thievery.emit()
