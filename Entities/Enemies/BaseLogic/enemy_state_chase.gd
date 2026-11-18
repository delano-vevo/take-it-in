extends State
## Implements basic behavior for chasing down a player, using the NavigationAgent2D
## in the parent node to chase after the player's last spotted position

## State links
@export var idle_state: State

## Gameplay variables
@onready var last_seen_position: Vector2 ## The position to move towards - the last seen position of the player

func state_entered(parent: Entity) -> void:
	# Play the walking animation
	parent.move_playback.travel("Walk")
	# TODO: swap this for a running animation if time permits
	parent.player_spotted.emit()
	# TODO: add a little graphic here to indicate the enemy has spotted the player (read: rip off MGS)
	parent.do_alert()
	# Capture the player's current position as the last seen position
	last_seen_position = parent.player.global_position

## Game loop
func physics_process(delta: float, parent: Entity) -> State:
	# Update the last seen position as long as the enemy has line of sight on the player
	if (parent.look_for_player()):
		# Update facing in parent to keep looking at the player
		parent.facing = rad_to_deg(parent.global_position.angle_to_point(parent.player.global_position))
		# Make sure the player position is a legal coordinate in the navigation polygon for the level
		if (parent.level.is_point_in_navmesh(parent.player.global_position)):
			last_seen_position = parent.player.global_position
	# Check if the enemy has yet reached the last seen position
	if (parent.global_position.distance_to(last_seen_position) > (parent.chase_speed * delta)+4): # Small offset here to prevent weirdness around floating point calculations not properly triggering idle state
		# Invoke the NavigationAgent in the Enemy to path to the next patrol point
		parent.nav_agent.target_position = last_seen_position
		var move_dir = parent.global_position.direction_to(parent.nav_agent.get_next_path_position())
		# Pass calculated movement direction to the parent's physics code
		parent.velocity = move_dir * parent.chase_speed
		parent.move_and_slide()
		# Pass calculated movement direction to the parent's animation blend positions
		if (abs(move_dir.x) < 0.1): # Small threshold for x-movement to avoid weirdness on micro-adjustments from navigationagent
			parent.set_blend_spaces(Vector2(0,sign(move_dir.y)))
		else:
			parent.set_blend_spaces(Vector2(sign(move_dir.x),0))
	else:
		# When the last seen position is reached, revert to idle state
		parent.global_position = last_seen_position
		parent.player_lost.emit(parent)
		return idle_state
	# No exit conditions encountered - continue pursuit
	return null
