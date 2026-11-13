class_name Player
extends Entity
## Implements the game's Player controller as a subtype of Entity

## Initialize
func _ready() -> void:
	# Set initial blend space values to avoid weirdness in the animation tree
	set_blend_spaces(Vector2(1,0))
	# Call superclass init
	super()

## Set ALL AnimationTree BlendSpaces based on a provided input vector
func set_blend_spaces(target: Vector2) -> void:
	# Enfore a check on the target Vector2 that stipulates ONLY X or Y axis can have value
	if (target.x != 0 and target.y != 0):
		print("ERROR!: set_blend_spaces provided a target Vector2 with invalid data: " + str(target))
	else:
		# Pass valid inputs along to the blend spaces
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", target)
		animation_tree.set("parameters/MoveStateMachine/Run/blend_position", target)
