extends Control
## Handles the logic for the level timer

## Editor nodes
@export var timer_label: Label

## Sets the label value based on the provided time remaining
func set_time(seconds: float) -> void:
	timer_label.set_text("TAKE IT IN %.0f SECONDS" % seconds)
