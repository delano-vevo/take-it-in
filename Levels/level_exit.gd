extends Area2D
## Handles behavior for the level exit door

## Signals
signal level_end

## Editor nodes
@export var door_sprite: Sprite2D

## Handles opening/closing the door based on the open range
func _on_door_open_range_body_entered(body: Node2D) -> void:
	if (body is Player):
		door_sprite.frame = 1
func _on_door_open_range_body_exited(body: Node2D) -> void:
	if (body is Player):
		door_sprite.frame = 0

## Body entered in the level exit area - if player, trigger level end
func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		print("Exiting level")
		level_end.emit()
