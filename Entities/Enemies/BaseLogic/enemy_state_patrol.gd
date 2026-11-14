class_name EnemyStatePatrol
extends State
## Defines a set of shared patrol state behaviors common to all enemy types

## State links
@export var idle_state: State
@export var chase_state: State

## Internal variables
@onready var patrol_point: Vector2

func state_entered(parent: Entity) -> void:
	# Play the walking animation
	parent.move_playback.travel("Walk")
	# Increment the patrol point
	patrol_point = parent.advance_patrol_point()

func physics_process(delta: float, parent: Entity) -> State:
	# See if the enemy can spot the player
	if (parent.look_for_player()):
		return chase_state
	# Walk the parent towards the next patrol point, if it's still out of range
	if (parent.global_position.distance_to(patrol_point) > parent.move_speed * delta):
		# Invoke the NavigationAgent in the Enemy to path to the next patrol point
		parent.nav_agent.target_position = patrol_point
		var move_dir = parent.global_position.direction_to(parent.nav_agent.get_next_path_position())
		# Pass calculated movement direction to the parent's physics code
		parent.velocity = move_dir * parent.move_speed
		parent.move_and_slide()
		# Update the parent's facing direction based on movement
		parent.facing = rad_to_deg(move_dir.angle())
		# Pass calculated movement direction to the parent's animation blend positions
		if (abs(move_dir.x) < 0.1): # Small threshold for x-movement to avoid weirdness on micro-adjustments from navigationagent
			parent.set_blend_spaces(Vector2(0,sign(move_dir.y)))
		else:
			parent.set_blend_spaces(Vector2(sign(move_dir.x),0))
	else:
		# Snap to the patrol point and return to the idle state
		parent.global_position = patrol_point
		return idle_state
	# No halts encountered - proceed with the patrol
	return null
