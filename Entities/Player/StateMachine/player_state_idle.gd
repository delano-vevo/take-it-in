extends State

## State links
@export var run_state: State

func state_entered(parent: Entity) -> void:
	# Play the idle animation
	parent.move_playback.travel("Idle")

func process(_delta: float, _parent: Entity) -> State:
	# Check for movement input to change states
	if (Input.get_axis("move_left","move_right")!=0 or Input.get_axis("move_up","move_down")!=0):
		return run_state
	else:
		return null
