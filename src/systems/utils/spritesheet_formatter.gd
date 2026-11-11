@tool
class_name SpriteSheetFormatter
extends Sprite2D

enum style {HORIZONTAL, VERTICAL}
@export var strip_style: style = style.HORIZONTAL

# helpful if you wanna format it on the fly
@export_group("Sheet information")
@export_tool_button("Format") var formatter = refresh_frame_splitting
@export var frame_dimensions: Vector2i:
	set(_dims):
		if Engine.is_editor_hint(): frame_dimensions = _dims.clamp(Vector2i.ZERO, texture.get_size())
		else: frame_dimensions = _dims

@export var frame_count		: int = 1;
var frame_h_count	: int = 1
var frame_v_count	: int = 1

@export_group("Sheet progress")
@export var progress: int = 0:
	set = __set_progress

var column: float
var cached_column: float
var column_within_bounds: bool = false

var row: float = 0:
	set = __set_row
var cached_row: float = 0
var row_within_bounds: bool = false

func _ready() -> void: 
	set_physics_process(!Engine.is_editor_hint())
	set_process(false)
	set_process_input(false)
	texture_changed		.connect(format)
	visibility_changed	.connect(set_process.bind(self.visible))
	
func refresh_frame_splitting() -> void:
	format()
	
func format(_spr: Texture2D = texture) -> void:	
	if _spr:
		
		
		match strip_style:
			style.HORIZONTAL:
				frame_h_count = int(_spr.get_width() / clampi(frame_dimensions.x, 1, frame_dimensions.x / frame_count))
				frame_v_count = int(_spr.get_height() / clampi(frame_dimensions.y, 1, frame_dimensions.y))
			style.VERTICAL:
				frame_h_count = int(_spr.get_width() / clampi(frame_dimensions.x, 1, frame_dimensions.x))
				frame_v_count = int(_spr.get_height() / clampi(frame_dimensions.y, 1, frame_dimensions.y / frame_count))
	 
		cached_row = row
		check_row()
		attempt_row()
	
		self.hframes = clamp(frame_h_count, 1, frame_h_count)
		self.vframes = clamp(frame_v_count, 1, frame_v_count)

func check_row() -> void:
	if row > frame_v_count - 1: row = frame_v_count - 1
func attempt_row() -> void:
	row = cached_row if cached_row <= frame_v_count - 1 else row

func set_sprite(_spr: Texture2D) -> void:
	if _spr == null: return
	format(_spr)
	texture = _spr

# - internal
func __set_row(_r: float) -> void:
	row = clamp(_r, 0, frame_v_count - 1)
	__set_progress(progress)
func __set_column(_c: float) -> void:
	column = clamp(_c, 0, frame_h_count - 1)
	__set_progress(progress)
	
func __set_progress(_progress: int) -> void:
	match strip_style:
		style.HORIZONTAL:
			progress = wrap(_progress, 0 , frame_h_count)
			frame_coords.x = clamp(progress, 0, frame_h_count)
			frame_coords.y = clamp(snapped(row, 0.5), 		0, frame_v_count)
			row_within_bounds = row <= frame_v_count - 1
		style.VERTICAL:
			progress = wrap(_progress, 0 , frame_v_count)
			frame_coords.x = clamp(round(column), 	0, frame_h_count)
			frame_coords.y = clamp(round(progress),	0, frame_v_count)
			column_within_bounds = cached_column <= frame_h_count - 1
