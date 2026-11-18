extends Enemy
## Implements a simple Guard type enemy with a flashlight and a basic patrol route

## Signals
## Used in State code from parent pointer - can disregard unused signal warnings
@warning_ignore("unused_signal")
signal player_spotted ## Triggered when the guard spots the player
@warning_ignore("unused_signal")
signal player_lost(enemy: Enemy) ## Triggered when the guard loses the player

## Editor nodes
@export var nav_agent: NavigationAgent2D ## The NavigationAgent2D this will use to traverse the level
@export var level: Level ## The level this enemy belongs to
@export var arrest_state: State ## This should probably be in the FSM but who cares I'm not adding a whole script just for this
@export var alert_sfx: AudioStreamPlayer ## Plays the Alert sound when the player is spotted
@export var exclamation_point: Sprite2D ## The Sprite2D for That effect (you know the one)
@export var exclamation_timer: Timer ## In tandem with the above, see do_alert()

## Set the blend spaces for the guard's animations
func set_blend_spaces(target: Vector2) -> void:
	if (target.x != 0 and target.y != 0):
		# Show the error for debugging
		print("Problem in " + str(self) + ": illegal blend space setting attempted: " + str(target))
	else:
		# Pass valid inputs along to the blend spaces
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", target)
		animation_tree.set("parameters/MoveStateMachine/Walk/blend_position", target)

## Called when the enemy is alerted to the player's position
func do_alert() -> void:
	alert_sfx.playing = true
	exclamation_point.visible = true
	exclamation_timer.start()
func _on_exclamation_point_timer_timeout() -> void:
	exclamation_point.visible = false

## Handles a signal from the Area2D responsible for catching the player
func _on_catch_area_body_entered(body: Node2D) -> void:
	if (body is Player):
		state_machine.set_state(arrest_state)
		body.get_caught()
