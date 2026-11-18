extends Node
## Defines global values for the game

## Map security level Enum values to Strings for UI display
const SECURITY_LEVELS: Dictionary[Enum.SecurityTiers, String] = {
	Enum.SecurityTiers.LOW: "Low",
	Enum.SecurityTiers.MEDIUM: "Medium",
	Enum.SecurityTiers.HIGH: "High",
	Enum.SecurityTiers.MAX: "MAXIMUM",
}

## Map level size Enum values to Strings for UI display
const LEVEL_SIZES: Dictionary[Enum.LevelSize, String] = {
	Enum.LevelSize.SMALL: "Small",
	Enum.LevelSize.MEDIUM: "Medium",
	Enum.LevelSize.LARGE: "Large",
}

## Keeps track of whether the player needs tutorialized
var tutorial: bool = true

## Keeps track of what levels have been cleared already
## Stores data in the form of [path_to_level String, is_cleared: bool key-value pairs]
var levels_cleared: Dictionary[String, bool] = {
	"res://Levels/Level1.tscn": false,
	"res://Levels/Level1_2.tscn": false,
	"res://Levels/Level2.tscn": false,
	"res://Levels/Level3.tscn": false,
	"res://Levels/Level3_2.tscn": false,
	"res://Levels/Level4.tscn": false,
	"res://Levels/Level5.tscn": false,
	"res://Levels/Level6.tscn": false,
}
