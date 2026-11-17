extends Control
## The controller for the intro sequence to the game

## The intro screens, in order of presentation
const SCREENS: Array = [
	preload("res://IntroSequence/Assets/intro_tv.png"),
	preload("res://IntroSequence/Assets/bossman_idea.png"),
	preload("res://IntroSequence/Assets/the_mission.png")
]
## Load in Main to instantiate once the intro is finished
const main_tscn: PackedScene = preload("res://Main.tscn")

## Editor nodes
@export var continue_button: Button
@export var intro_graphic: TextureRect ## Displays the above Screens
@export var fade_anim: AnimationPlayer ## Plays the fade effect between screens

## Internal variables
@onready var screen_idx: int = 0  ## The index of the current screen in SCREENS

## Updates the screen - called from animation player
func next_screen() -> void:
	screen_idx += 1
	intro_graphic.set_texture(SCREENS[screen_idx])

## "Continue" pressed - advance the screens
func _on_button_pressed() -> void:
	print(str(screen_idx) + "/" + str(SCREENS.size()))
	if (screen_idx < SCREENS.size()-1):
		fade_anim.play("fade")
	else:
		get_tree().change_scene_to_packed(main_tscn)
		#await get_tree().scene_changed
		print("Start the game!")
		queue_free()

## Toggles disabled on the continue button; invoked from animation player
func toggle_button_active() -> void:
	if (continue_button.disabled):
		continue_button.disabled = false
	else:
		continue_button.disabled = true
