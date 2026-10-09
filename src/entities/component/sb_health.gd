class_name SBHealth
extends SBComponent

const DEF_MAX_HEALTH: float = 1
const DEF_BLOOD_COLOR: Color = Color(Color.DARK_RED)

var max_health: float = DEF_MAX_HEALTH 
var health: float = DEF_MAX_HEALTH
var health_regen: float = 0.02

var grace_hit_enabled: bool = true
var grace_hit_value: bool = 0.3
var death: SBComponent

@export var blood_particles: CPUParticles2D
@export var blood_color: Color = DEF_BLOOD_COLOR

signal took_damage(_dmg: float)

func _setup(_sentient: Actor2D = null) -> void:
	super(_sentient)
	blood_particles = Utils.get_child_node_or_null(self, "blood_particles")
	if blood_particles == null: 
		blood_particles = await Utils.add_child_node(self, CPUParticles2D.new(), "blood_particles")
	
	blood_particles.emitting = false
	blood_particles.one_shot = true
	Utils.connect_to_signal(blood_particles.restart.bind(false), took_damage)
func _take_damage() -> void: pass
