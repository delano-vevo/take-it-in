class_name Enemy
extends Entity
## Defines the base of an Enemy-type Entity

## Editor variables
## All Enemies will have a patrol path, defined as a list of points to move to (in global coordinates!);
## can be defined per-instance in level editing
@export var patrol_path: Array[Vector2]

## Internal variables
@onready var next_patrol_point: int = 0 ## An index into the patrol_path array to point the enemy towards the next patrol point, when relevant

## Obtain the next patrol point based on internal index
func get_next_patrol_point() -> Vector2:
	return patrol_path[next_patrol_point]

## Advance to the next patrol point
func advance_patrol_point() -> Vector2:
	next_patrol_point += 1
	if (next_patrol_point >= patrol_path.size()):
		next_patrol_point = 0
	return get_next_patrol_point()
