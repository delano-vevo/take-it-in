extends Control
## Displays the UI element for counting up the player's money

## Editor nodes
@export var money_label: Label ## The Label responsible for displaying the total money
@export var bounty_label: Label ## The Label responsible for displaying the level's bounty amount

## Used to update the current money amount
func set_money(amount: float, bounty: float) -> void:
	money_label.set_text("$%.2f" % amount)
	bounty_label.set_text("$%.2f" % bounty)
