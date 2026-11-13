extends Node2D
## Responsible for controlling the thievery minigame

## Signals
signal thievery_done ## Used to hand control back off to current_level in Main
signal get_money(amount: float) ## Propagated from ThiefBag to pass to Main

## Editor nodes
@export var hand: Node2D

## Handle button press to exit the minigame
func _on_button_pressed() -> void:
	thievery_done.emit()
	queue_free()

## Propagate a get_money signal up to Main
func _on_thief_bag_get_money(amount: float) -> void:
	get_money.emit(amount)
