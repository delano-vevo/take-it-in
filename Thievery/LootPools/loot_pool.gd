extends Node2D
## Simple script to keep a helper polygon from accidentally showing up in the game

func _ready() -> void:
	$Polygon2D.visible = false
