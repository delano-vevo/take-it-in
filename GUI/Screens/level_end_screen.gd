extends Control
## Handles the UI for the screen displayed when the player exits a level

func _ready() -> void:
	# Tween modulate for a fade-in effect
	modulate = Color(1,1,1,0)
	var mod_tween = get_tree().create_tween()
	mod_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	mod_tween.tween_property(self, "modulate", Color.WHITE, 0.5)

func _on_button_pressed() -> void:
	pass # Replace with function body.
