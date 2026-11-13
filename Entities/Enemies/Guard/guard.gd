extends Enemy

func set_blend_spaces(target: Vector2) -> void:
	if (target.x != 0 and target.y != 0):
		# Show the error for debugging
		print("Problem in " + str(self) + ": illegal blend space setting attempted: " + str(target))
	else:
		# Pass valid inputs along to the blend spaces
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", target)
		animation_tree.set("parameters/MoveStateMachine/Walk/blend_position", target)
