class_name Goodie
extends RigidBody2D
## Implements a generic goodie/trinket/bauble/etc. that the player can grab for money in the thievery minigame

## Gameplay variables
@export var money_amount: float = 1.0 ## The amount of money this particular goodie is worth
@onready var position_offset: Vector2 ## An offset value set when this object is grabbed to determine manual positioning
@onready var hand: Sprite2D ## Keeps a reference to the Hand sprite from TheifHand controller for positional code while grabbed

## Initialize
func _ready() -> void:
	# TODO: decide what freeze mode to use after further testing
	pass#freeze_mode = FREEZE_MODE_KINEMATIC

## Game loop
#func _integrate_forces(state) -> void:
func _physics_process(delta: float) -> void:
	if (freeze):
		# Override physics with manual position based on hand offset
		var targ_position: Vector2 = hand.global_position + position_offset
		global_transform.origin = targ_position

## Called when grabbed by the hand
func grabbed(grab_hand: Sprite2D) -> void:
	hand = grab_hand # Save reference
	freeze = true
	# Capture position offset
	position_offset = global_position - hand.global_position

## Called when released by the hand
func released() -> void:
	if (freeze):
		apply_central_impulse(Input.get_last_mouse_velocity())
		freeze = false
