extends State

func state_entered(parent: Entity) -> void:
	# TODO: add a specialized animation here if time allows
	parent.move_playback.travel("Idle")
