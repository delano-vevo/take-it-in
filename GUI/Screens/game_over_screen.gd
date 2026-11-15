extends Control
## Implements VFX for the game over screen

## Signals
signal restart_game ## Used to signal to Main to restart the game

## Initialize
func _ready() -> void:
	# Tween modulate for a fade-in effect
	modulate = Color(1,1,1,0)
	var mod_tween = get_tree().create_tween()
	mod_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	mod_tween.tween_property(self, "modulate", Color.WHITE, 0.5)

## Restart button - signal to Main to restart
func _on_button_pressed() -> void:
	restart_game.emit()
