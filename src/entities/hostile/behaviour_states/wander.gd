extends SBNestedState

var direction: Vector2i = Vector2i(1, 1)


# heres how it should work.
# 	1. first it waits for the duration of idle_wait_time
#	2. once the timer ends, it sets a new location and a new wait time.
#	3. the entity moves if its not at the target.
#	4. once it reaches the destination, restarts the timer.

func _enter_sub_state() -> void: 
	set_sub_state("wander_idle")
	
	(actor as NavSentient).nav_agent.target_desired_distance = 10
	(actor as NavSentient).nav_agent.set_navigation_layer_value(2, true)
	(actor as NavSentient).nav_agent.set_navigation_layer_value(3, false)
