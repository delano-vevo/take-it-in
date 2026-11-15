class_name Player
extends Entity
## Implements the game's Player controller as a subtype of Entity

## Signals
signal game_over ## Signal to Main that the player dun got caught

## Editor nodes
@export var animation_player: AnimationPlayer ## Used to call special state animations
@export var crying_particles_l: GPUParticles2D ## The particle effects for the player weeping when caught
@export var crying_particles_r: GPUParticles2D

## Initialize
func _ready() -> void:
	# Set initial blend space values to avoid weirdness in the animation tree
	set_blend_spaces(Vector2(1,0))
	# Call superclass init
	super()

## Game loop
func _process(delta: float) -> void:
	# Debug output - WHAT The fuck is happening with the animations lmao
	if (Input.is_action_just_pressed("debug_2")):
		print(animation_tree.get("parameters/MoveStateMachine/Idle/blend_position"))
		print(animation_tree.get("parameters/MoveStateMachine/Run/blend_position"))

## Invoked from Enemy detection radius; the player is caught and the game is over
func get_caught() -> void:
	state_machine.set_state(state_machine.caught_state)

## Set ALL AnimationTree BlendSpaces based on a provided input vector
func set_blend_spaces(target: Vector2) -> void:
	# Enfore a check on the target Vector2 that stipulates ONLY X or Y axis can have value
	if (target.x != 0 and target.y != 0):
		print("ERROR!: set_blend_spaces provided a target Vector2 with invalid data: " + str(target))
	else:
		# Pass valid inputs along to the blend spaces
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", target)
		animation_tree.set("parameters/MoveStateMachine/Run/blend_position", target)
