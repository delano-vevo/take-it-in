extends State

func state_entered(parent: Entity) -> void:
	print("Arresting the player!")
	# TODO: add a specialized animation here if time allows
	parent.move_playback.travel("Walk")
