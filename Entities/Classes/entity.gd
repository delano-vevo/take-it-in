class_name Entity
extends CharacterBody2D
## Implements a basic Entity type

## Editor variables
@export var state_machine: StateMachine ## All Entities will be controlled using StateMachine logic
@export var animation_tree: AnimationTree

## Gameplay variables
@export var move_speed: float ## The speed at which the Entity moves through the world

## Internal variables
@onready var move_playback: AnimationNodeStateMachinePlayback ## The playback for the movement anim state machine in the AnimationTree

## Initialize
func _ready() -> void:
	# Turn on the animation tree
	animation_tree.active = true
	# Fetch the playback from the animation tree
	move_playback = animation_tree.get("parameters/MoveStateMachine/playback")
