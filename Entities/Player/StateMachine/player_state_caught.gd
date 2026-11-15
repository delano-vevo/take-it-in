extends State

func state_entered(parent: Entity) -> void:
	print("Oh no I dun got caught it's game over for me jack")
	parent.animation_tree.active = false
	parent.crying_particles_l.visible = true
	parent.crying_particles_r.visible = true
	parent.crying_particles_l.emitting = true
	parent.crying_particles_r.emitting = true
	parent.animation_player.play("caught")
	parent.game_over.emit()
