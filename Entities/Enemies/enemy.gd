class_name Enemy
extends Entity
## Defines the base of an Enemy-type Entity

## Editor variables
## All Enemies will have a patrol path, defined as a list of points to move to (in global coordinates!);
## can be defined per-instance in level editing
@export var patrol_path: Array[Vector2]
@export var sight_ray: RayCast2D ## The RayCast used to detect line of sight to the player

## Gameplay variables
@export var max_look_range: float = 200.0 ## The maximum distance at which the guard will "spot" the player
@export var max_look_angle: float = 80.0 ## The maximum angle, in degrees, that the player can be away from the enemy's facing direction and still be detected
@export var chase_speed: float = 100.0 ## The speed at which the enemy runs when pursuing the player
@export var hear_range: float = 30.0 ## The range at which a guard can hear the player approaching and detect them even if facing another direction

## Internal variables
@onready var next_patrol_point: int = 0 ## An index into the patrol_path array to point the enemy towards the next patrol point, when relevant
@onready var player: Player ## Maintains a pointer to the Player node for LoS checks and the like
@onready var facing: float ## The angle (IN DEGREES) that the enemy is currently facing

## Obtain the next patrol point based on internal index
func get_next_patrol_point() -> Vector2:
	return patrol_path[next_patrol_point]

## Advance to the next patrol point
func advance_patrol_point() -> Vector2:
	next_patrol_point += 1
	if (next_patrol_point >= patrol_path.size()):
		next_patrol_point = 0
	return get_next_patrol_point()

## Looks for the player and returns boolean indicating success/failure
func look_for_player() -> bool:
	# Only run when reference to player has been properly initialized
	if (player != null):
		# Check if the player is in range
		if (global_position.distance_to(player.global_position) <= max_look_range):
			# Check if the player is in the same direction the enemy is currently facing
			# OR, if the player is within an inner radius that allows detection based on sound
			if (global_position.distance_to(player.global_position) <= hear_range or abs(rad_to_deg(global_position.angle_to_point(player.global_position)) - facing) <= max_look_angle):
				# Update the raycast and check if it sees the player
				sight_ray.target_position = player.global_position - global_position
				sight_ray.force_raycast_update()
				if (sight_ray.get_collider() is Player):
					# If all of these conditions are met, the enemy can see the player!
					return true
	# No success condition encountered - report failure
	return false
