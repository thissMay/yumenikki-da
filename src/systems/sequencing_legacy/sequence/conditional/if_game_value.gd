extends ConditionalEvent

enum scope {SCENE, GLOBAL}

enum operation {
	EQUALS, 
	NOT_EQUALS, 
	GREATER, 
	GREATER_EQUALS, 
	LESS, 
	LESS_EQUALS}
	
var scene_path
@export var value_scope: scope = scope.SCENE
@export var comparison_operator: operation = operation.EQUALS
