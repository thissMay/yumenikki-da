extends PLEffect

const NORMAL_LOCATION_CHANCE: float = 0.7
const DAMNED_LOCATION_CHANCE: float = 0.3

var chance_value: 			float = 0:
	set(_val): chance_value = clampf(_val, 0, 1)
var rolled: 				bool = false
