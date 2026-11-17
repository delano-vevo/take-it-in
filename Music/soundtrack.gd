extends AudioStreamPlayer
## Controls the audio streams that comprise the in-game soundtrack

## Constants
const REGULAR_VOLUME: float = 0.0 ## Target volume when a stream is playing
const MUTE_VOLUME: float = -60.0 ## Target volume when a stream is muted
const FADE_TIME: float = 1.0 ## The time (in seconds) a track will take to fade in or out

## Internal variables
@onready var shaker_volume: float = MUTE_VOLUME
@onready var drum_volume: float = MUTE_VOLUME
@onready var bassline_volume: float = MUTE_VOLUME
@onready var melody_volume: float = MUTE_VOLUME

## Game loop
func _process(_delta: float) -> void:
	# Doing this every frame seems kind of stupid, but this is the only
	# way I can think to make the track volumes tweenable so fuck it we ball
	stream.set_sync_stream_volume(0,shaker_volume)
	stream.set_sync_stream_volume(1,drum_volume)
	stream.set_sync_stream_volume(2,bassline_volume)
	stream.set_sync_stream_volume(3,melody_volume)

## Fade-in and fade-out calls for the tracks
# Would it really be a game jam without a big fucking stupid block of switch statements? I think not :D
func fade_in_track(track: Enum.AudioTracks) -> void:
	var vol_tween = get_tree().create_tween()
	vol_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	match track:
		Enum.AudioTracks.SHAKERS:
			vol_tween.tween_property(self,"shaker_volume",REGULAR_VOLUME,FADE_TIME)
		Enum.AudioTracks.DRUMLINE:
			vol_tween.tween_property(self,"drum_volume",REGULAR_VOLUME,FADE_TIME)
		Enum.AudioTracks.BASSLINE:
			vol_tween.tween_property(self,"bassline_volume",REGULAR_VOLUME,FADE_TIME)
		Enum.AudioTracks.MELODY:
			vol_tween.tween_property(self,"melody_volume",REGULAR_VOLUME,FADE_TIME)
func fade_out_track(track: Enum.AudioTracks) -> void:
	var vol_tween = get_tree().create_tween()
	vol_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	match track:
		Enum.AudioTracks.SHAKERS:
			vol_tween.tween_property(self,"shaker_volume",MUTE_VOLUME,FADE_TIME)
		Enum.AudioTracks.DRUMLINE:
			vol_tween.tween_property(self,"drum_volume",MUTE_VOLUME,FADE_TIME)
		Enum.AudioTracks.BASSLINE:
			vol_tween.tween_property(self,"bassline_volume",MUTE_VOLUME,FADE_TIME)
		Enum.AudioTracks.MELODY:
			vol_tween.tween_property(self,"melody_volume",MUTE_VOLUME,FADE_TIME)
