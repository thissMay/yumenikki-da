class_name BGMPlayer
extends SoundPlayer

enum BUS {MUSIC, AMBIENCE, ALL}

## The 'Music Container' is going to act as a 
## container for any ambience stream player instances.
const MUSIC_DICT := {
	"stream" : null, 
	"volume" : 1, 
	"pitch" : 1, 
	"carry_over": false}

@onready var prev_music 	:= MUSIC_DICT.duplicate()
@onready var curr_music 	:= MUSIC_DICT.duplicate()
@onready var pending_music 	:= MUSIC_DICT.duplicate()

var vol_tween: Tween
var pitch_tween: Tween

@onready var scene_change_request_listener := EventListener.new(self, "SCENE_CHANGE_REQUEST")

func _ready() -> void:
	self.autoplay = false
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	scene_change_request_listener.do_on_notify(fade_out, "SCENE_CHANGE_REQUEST")
func play_sound(
	_stream: AudioStream, 
	_vol: 	float = 1, 
	_pitch: float = 1,
	_abrupt: bool = false) -> void:
	
	if playing: set_music_dict(pending_music, _stream, _vol, _pitch)
		
	set_music_dict(prev_music, curr_music["stream"], curr_music["volume"], curr_music["pitch"])
	set_music_dict(curr_music, _stream, _vol, _pitch)
	
	if same_as_previous():
		tween_pitch(self.pitch_scale, get_bgm_pitch())
		tween_volume(self.volume_db, get_bgm_volume())
	
	else:
		set_pitch(get_bgm_pitch())
		set_stream(get_bgm_stream()) 
		
		if _abrupt: volume_db = get_bgm_volume()
		else:		fade_in()			
		self.play()

func set_music_dict(
	_target_dict: Dictionary, 
	_stream: AudioStream, 
	_vol: float,
	_pitch: float) -> void:
		_target_dict["stream"] = _stream
		_target_dict["volume"] = _vol
		_target_dict["pitch"] = _pitch
			
# ---- getters ----
func get_bgm_volume() -> float: 		return curr_music["volume"]
func get_bgm_pitch() -> float:  		return curr_music["pitch"]
func get_bgm_stream() -> AudioStream: 	return curr_music["stream"]

# ---- setters ----
func tween_pitch(_from: float, _pitch: float) -> void:
	if pitch_tween != null: pitch_tween.kill()
	pitch_tween = self.create_tween()	
	pitch_tween.tween_method(set_pitch, _from, _pitch, 1)
func tween_volume(_from: float, _vol: float) -> void:
	if vol_tween != null: vol_tween.kill()
	vol_tween = self.create_tween()	
	
	volume_db = _from
	vol_tween.tween_method(set_volume, _from, _vol, 2)

	await vol_tween.finished
func fade_in() -> void: 	tween_volume(ZERO_VOLUME_DB, get_bgm_volume())
func fade_out() -> void: 	
	await tween_volume(get_bgm_volume(), ZERO_VOLUME_DB)
	stream = null

# ---- logic ----
func same_as_previous() -> bool: 
	if prev_music and curr_music: 
		return prev_music["stream"] == curr_music["stream"]
	return false
	
