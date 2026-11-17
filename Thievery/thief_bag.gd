extends Area2D
## Controls the bag that gobbles up all the goodies the player sends its way

## Signals
signal get_money(amount: float)

## Editor nodes
@export var sfx: AudioStreamPlayer ## Plays the money get SFX

## On body entered, detect whether it's a Goodie
func _on_body_entered(body: Node2D) -> void:
	if (body is Goodie):
		sfx.play()
		get_money.emit(body.money_amount)
		body.queue_free()
