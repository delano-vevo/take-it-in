extends Node2D
## Controller for the player's hand in the thievery minigame

## Editor nodes
@export var hand_sprite: Sprite2D ## The Sprite that displays the player's hand
@export var hand_area: Area2D ## The detection Area for grabbing objects with the hand
@export var arm_line: Line2D ## The Line graphic responsible for drawing an arm from the origin to the hand position

## Input handler - used to process grabs as they happen and apply physics to any Goodies the hand has yoinked
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (Input.is_action_just_pressed("grab")):
			# On grab, check for overlap in hand_area and grab all goodies
			for body in hand_area.get_overlapping_bodies():
				if body is Goodie:
					body.grabbed(hand_sprite)
		elif (Input.is_action_just_released("grab")):
			for goodie in get_tree().get_nodes_in_group("goodies"):
				goodie.released()

## Game loop
func _process(delta: float) -> void:
	# Set hand position based on mouse
	hand_sprite.global_position = get_global_mouse_position()
	# Update hand rotation based on direction from origin
	hand_sprite.rotation = global_position.angle_to_point(hand_sprite.global_position)
	# Update arm line to extend to the base of the hand
	arm_line.clear_points()
	arm_line.add_point(Vector2.ZERO)
	arm_line.add_point(hand_sprite.position)
	# Check for input to close the hand
	if (Input.is_action_pressed("grab")):
		hand_sprite.frame = 1
	else:
		hand_sprite.frame = 0
