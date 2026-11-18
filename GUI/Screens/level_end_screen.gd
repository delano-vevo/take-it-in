extends Control
## Handles the UI for the screen displayed when the player exits a level

signal restart_game

@export var rank_label: Label ## Displays the player's rank

func _ready() -> void:
	# Tween modulate for a fade-in effect
	modulate = Color(1,1,1,0)
	var mod_tween = get_tree().create_tween()
	mod_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	mod_tween.tween_property(self, "modulate", Color.WHITE, 0.5)

# Gives the player a level ranking based on their extra money
func do_rank(extra_money: float) -> void:
	var rank: String
	if (extra_money >= 40.0):
		rank = 'S'
	elif (extra_money >= 30.0):
		rank = 'A'
	elif (extra_money >= 20.0):
		rank = 'B'
	elif (extra_money >= 10.0):
		rank = 'C'
	else:
		rank = 'D'
	rank_label.set_text("Level rank: " + rank + " - $%.2f over quota" % extra_money)

func _on_button_pressed() -> void:
	restart_game.emit()
