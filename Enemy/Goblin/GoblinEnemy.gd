class_name Goblin extends Enemy

@export_category("Goblin References")
## Cast downward, slightly ahead of the feet, to detect ledges while patrolling.
@export var floor_ray: RayCast2D
## Optional forward ray; walls are detected via is_on_wall() so this is unused for now.
@export var wall_ray: RayCast2D


## Returns true when there is no floor ahead in the travel direction (a ledge),
## so the patrol state knows to turn around instead of walking off the platform.
func at_ledge(direction: float) -> bool:
	if floor_ray == null or not floor_ray.enabled:
		return false

	# Only meaningful while grounded; mid-air there is never floor ahead.
	if not is_on_floor():
		return false

	# Aim the ray ahead in the direction we're moving, then sample it now.
	floor_ray.position.x = absf(floor_ray.position.x) * signf(direction)
	floor_ray.force_raycast_update()

	return not floor_ray.is_colliding()
