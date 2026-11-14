class_name LootSource
extends StaticBody2D
## Defines base behaviors for a lootable object within the game

## Signals
signal looted ## Called when a valid looting prompt is detected

## Editor nodes
@export var interact_prompt: Control ## The prompt display that shows when the player gets close
@export var obj_sprite: Sprite2D ## The Sprite displaying this object in the world

## Gameplay variables
@onready var player_overlap: bool = false ## Tracks whether the player is within interact range
@onready var is_looted: bool = false ## Tracks whether this object has already been looted

## Input handler - detects looting input
func _input(event: InputEvent):
	if (event is InputEventKey):
		if (Input.is_action_just_pressed("loot")):
			if (player_overlap):
				if (!is_looted):
					# All conditions met - time for thievery!
					looted.emit()
					is_looted = true
					# Set the frame up by 1 to swap to looted graphics
					obj_sprite.frame = 1

## Handle body detection in the InteractArea child
# TODO: make this prettier with tweens if time allows
func _on_interact_area_body_entered(body: Node2D) -> void:
	if (body is Player and !is_looted):
		# Display the interaction popup
		interact_prompt.visible = true
		# Track the player
		player_overlap = true
func _on_interact_area_body_exited(body: Node2D) -> void:
	if (body is Player):
		# Hide the interaction popup
		interact_prompt.visible = false
		# Untrack the player
		player_overlap = false
