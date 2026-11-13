class_name EnemyStatePatrol
extends State
## Defines a set of shared patrol state behaviors common to all enemy types

## State links
@export var idle_state: State

## Internal variables
@onready var patrol_point: Vector2

func state_entered(parent: Entity) -> void:
	# Play the walking animation
	parent.move_playback.travel("Walk")
	# Increment the patrol point
	patrol_point = parent.advance_patrol_point()

func physics_process(delta: float, parent: Entity) -> State:
	# Update animation blend spaces based on walk direction
	# Walk the parent towards the next patrol point
	if (parent.global_position.distance_to(patrol_point) > parent.move_speed * delta):
		var move_dir = parent.global_position.direction_to(patrol_point)
		# Set the blend spaces in the parent
		parent.set_blend_spaces(move_dir)
		# Apply movement to the enemy
		parent.velocity = move_dir * parent.move_speed
		parent.move_and_slide()
	else:
		parent.global_position = patrol_point
		return idle_state
	# No halts encountered - proceed with the patrol
	return null
