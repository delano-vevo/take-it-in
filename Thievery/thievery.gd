extends Node2D
## Responsible for controlling the thievery minigame

## Constants
const CONTAINER_POSITION: Vector2 = Vector2(220,160)

## Resource loads
const loot_pools: Array = [
	preload("res://Thievery/LootPools/LootPool1.tscn")
]
const loot_containers: Array = [
	preload("res://Thievery/LootContainers/BigJug.tscn"),
	preload("res://Thievery/LootContainers/BigVase.tscn"),
	preload("res://Thievery/LootContainers/JarThing.tscn"),
	preload("res://Thievery/LootContainers/LootBowl.tscn"),
	preload("res://Thievery/LootContainers/VaseThing.tscn"),
]

## Signals
signal thievery_done ## Used to hand control back off to current_level in Main
signal get_money(amount: float) ## Propagated from ThiefBag to pass to Main

## Editor nodes
@export var hand: Node2D

## Initialize - randomize loot and container
func _ready() -> void:
	var loot_container: StaticBody2D = loot_containers[randi_range(0,loot_containers.size()-1)].instantiate()
	var loot_pool: Node2D = loot_pools[randi_range(0,loot_pools.size()-1)].instantiate()
	loot_container.global_position = CONTAINER_POSITION
	add_child(loot_container)
	loot_container.add_child(loot_pool)

## Handle button press to exit the minigame
func _on_button_pressed() -> void:
	thievery_done.emit()
	queue_free()

## Propagate a get_money signal up to Main
func _on_thief_bag_get_money(amount: float) -> void:
	get_money.emit(amount)
