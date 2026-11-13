extends State

## State links
@export var idle_state: State

## Internal variables
@onready var last_pressed: String

func state_entered(parent: Entity) -> void:
	# Play the running animation
	parent.move_playback.travel("Run")

## Grab input directly from the _input signal to track last key press
## for movement constraints in physics_process below
func _input(event: InputEvent) -> void:
	if (event is InputEventKey):
		# Check specific keypresses for the four input directions
		# TODO: is there a way to get the string name from the actual event rather than use this big ugly if block?
		if (event.is_action_pressed("move_right")):
			last_pressed = "move_right"
		elif (event.is_action_pressed("move_left")):
			last_pressed = "move_left"
		elif (event.is_action_pressed("move_up")):
			last_pressed = "move_up"
		elif (event.is_action_pressed("move_down")):
			last_pressed = "move_down"

func physics_process(_delta: float, parent: Entity) -> State:
	# Get movement input and apply to the player
	var h_input = Input.get_axis("move_left", "move_right")
	var v_input = Input.get_axis("move_up", "move_down")
	var move_input: Vector2
	# Check for lack of input and return to idling if condition encountered
	if (h_input == 0 and v_input == 0):
		return idle_state
	# Movement is enforced on the player controller as a strict horizontal
	# OR vertical motion ONLY, never both directions at one time
	# This is dictated by the most recent button input, grabbed in the _input event handler above
	else:
		# This may well be overengineered but it feels so much better than the old version
		if (v_input == 0):
			move_input = Vector2(h_input,0)
		elif (h_input != 0 and (last_pressed=="move_left" or last_pressed=="move_right")):
			move_input = Vector2(h_input,0)
		else:
			move_input = Vector2(0,v_input)
	# Apply input to AnimationTree blend spaces
	parent.set_blend_spaces(move_input)
	# Apply input to player movement
	parent.velocity = move_input * parent.move_speed
	parent.move_and_slide()
	# No exit conditions encountered - continue running
	return null
