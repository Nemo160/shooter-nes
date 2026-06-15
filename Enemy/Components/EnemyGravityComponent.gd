class_name EnemyGravityComponent extends GravityComponent

@export var testGr: float = 155.0

#USE THIS CLASS INSTEAD OF BASE GRAVITY COMPONENT IF BEHAVIOR SHOULD BE DIFFERENT
## other wise stick with GravityComponent as since it already handles gravity
## dont use it for player though, player has different input behaviours!
