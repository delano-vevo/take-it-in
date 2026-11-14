extends Enemy
## Implements a simple Guard type enemy with a flashlight and a basic patrol route

## Editor nodes
@export var nav_agent: NavigationAgent2D ## The NavigationAgent2D this will use to traverse the level

## Set the blend spaces for the guard's animations
func set_blend_spaces(target: Vector2) -> void:
	if (target.x != 0 and target.y != 0):
		# Show the error for debugging
		print("Problem in " + str(self) + ": illegal blend space setting attempted: " + str(target))
	else:
		# Pass valid inputs along to the blend spaces
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", target)
		animation_tree.set("parameters/MoveStateMachine/Walk/blend_position", target)
