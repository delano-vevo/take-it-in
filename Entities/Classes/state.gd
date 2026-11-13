class_name State
extends Node
## Defines a State to be used by StateMachines for controlling entity logic

## Game loop - internal non-engine methods, called instead
## by the StateMachine that controls these States
@warning_ignore("unused_parameter")
func process(delta: float, parent: Entity) -> State:
	return null
@warning_ignore("unused_parameter")
func physics_process(delta: float, parent: Entity) -> State:
	return null

## State transition functions
@warning_ignore("unused_parameter")
func state_entered(parent: Entity) -> void:
	pass
@warning_ignore("unused_parameter")
func state_exited(parent: Entity) -> void:
	pass

## Checks whether this state is the current state in the StateMachine
func is_current_state() -> bool:
	if (get_parent().current_state == self):
		return true
	else:
		return false
