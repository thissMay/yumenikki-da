@tool
class_name EVN_IFExpression
extends ConditionalEvent

@export_custom(PROPERTY_HINT_EXPRESSION, "") var expression: String
@export var input_objects: Dictionary[String, Node] = {}

var expression_instance: Expression

func _predicate() -> bool:
	expression_instance = null
	expression_instance = Expression.new()
	var err = expression_instance.parse(expression, input_objects.keys())
	if 	err != OK: return false
	
	var res = expression_instance.execute(input_objects.values(), self)
	if expression_instance.has_execute_failed(): return false
	
	return (res is bool) and res
	

# - expression helpers.
