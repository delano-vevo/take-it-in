class_name EnemyStateIdle
extends State
## Defines a set of shared idle behaviors common to all enemy types

## State links
@export var patrol_state: State
@export var chase_state: State

## Editor nodes
@export var idle_wait: Timer ## The Timer that controls how long the enemy idles for before moving on

func state_entered(parent: Entity) -> void:
	# Play the idling animation in the parent Enemy
	parent.move_playback.travel("Idle")
	# Start the wait timer
	idle_wait.start()

func process(delta: float, parent: Entity) -> State:
	# Check to see if the player is spotted
	if (parent.look_for_player()):
		return chase_state
	# Poll the wait timer to see if it's expired
	elif (idle_wait.is_stopped()):
		return patrol_state
	else:
		return null
