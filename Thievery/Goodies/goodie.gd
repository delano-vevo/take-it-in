class_name Goodie
extends RigidBody2D
## Implements a generic goodie/trinket/bauble/etc. that the player can grab for money in the thievery minigame

## Constants
const DRAG_STRENGTH: float = 10.0 ## Strength with which the player hand drags the goodies
const MOUSE_DAMPING: float = 0.25 ## Damping applied to mouse_velocity on release
const CLINK_SOUNDS: Array = [
	preload("res://SFX/coin_clink.wav"),
	preload("res://SFX/coin_clink_2.wav"),
	preload("res://SFX/coin_clink_3.wav")
] ## This may play one of several random SFX when clinking
const SFX_THRESHOLD: float = 10.0 ## The minimum velocity for a collision to make a sound

## Editor nodes
@export var clink_sfx: AudioStreamPlayer ## The SFX node for the sound of the goodie clinking against another object

## Gameplay variables
@export var money_amount: float = 1.0 ## The amount of money this particular goodie is worth
@onready var position_offset: Vector2 ## An offset value set when this object is grabbed to determine manual positioning
@onready var hand: Sprite2D ## Keeps a reference to the Hand sprite from TheifHand controller for positional code while grabbed
@onready var is_grabbed: bool ## Maintains a boolean indicating whether the object is currently grabbed
@onready var is_released: bool = false ## Boolean that flips for a frame on object release; useful for physics code

## Initialize
func _ready() -> void:
	# Enable contact monitoring
	contact_monitor = true
	max_contacts_reported = 1
	# Randomize SFX
	clink_sfx.stream = CLINK_SOUNDS[randi_range(0,CLINK_SOUNDS.size()-1)]

## Game loop
## Grab code is handled in _integrate_forces() to retain physics properties while grabbing
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void: 
	if (is_grabbed):
		# Apply a dragging effect on grabbed, while maintaining physics state otherwise
		var lin_vel = global_position.direction_to(hand.global_position + position_offset)
		lin_vel *= global_position.distance_to(hand.global_position + position_offset)
		linear_velocity = lin_vel * DRAG_STRENGTH
	elif (is_released):
		# Zero out the velocity and apply last mouse velocity instead
		linear_velocity = Input.get_last_mouse_velocity() * MOUSE_DAMPING
		is_released = false # Flip the released flag back

## Called when grabbed by the hand
func grabbed(grab_hand: Sprite2D) -> void:
	hand = grab_hand # Save reference
	is_grabbed = true
	is_released = false
	# Capture position offset
	position_offset = global_position - hand.global_position

## Called when released by the hand
func released() -> void:
	if (is_grabbed):
		#linear_velocity = Vector2.ZERO
		apply_central_impulse(Input.get_last_mouse_velocity())
		is_grabbed = false
		is_released = true

## Detect collision with other goodies for SFX purposes
func _on_body_entered(body: Node) -> void:
	if (body is Goodie and !is_grabbed):
		if (self.linear_velocity.length() + body.linear_velocity.length() >= SFX_THRESHOLD):
			clink_sfx.play()
