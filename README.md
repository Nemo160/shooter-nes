# NES Shooter (working title)

A 2D action prototype built in Godot. The focus so far has been on building solid player
movement and enemy systems, not on visuals, which are intentionally not a priority yet.

## Tech stack

Godot Engine, GDScript

## Controls (current)

- Move left / right
- Jump (with air jump)
- Dash (with a short invincibility window)
- Hold down to fast-fall / descend faster

## Player Movement — Modular Components

Player movement is handled through modular components rather than one large script. The
`Player` class acts as a middleman for each component: it calls the engine's physics functions
every frame, which lets each component read input and act independently. Splitting the logic
this way keeps the project easier to scale and read.

Every component is exported to the inspector under the `Nodes` category.

**Note on component access**<br>
Every component connects through `Player`, which also means every component technically has
access to every other component's variables and functions through that shared `Player`
instance (e.g. calling `GravityComponent` logic from inside `JumpComponent`). **Avoid doing
this** — the instance referenced this way can be stale, and in the worst case it risks a
recursive loop if you're not careful.

## Class Diagram

![Class Diagram](Docs/class-diagram.png)

## Components

### 1. InputComponent

Handles user input through a single `update_input()` function, setting booleans based on
whether the corresponding action is pressed:

```gdscript
input_horizontal = Input.get_axis("left", "right")
jump_pressed = Input.is_action_just_pressed("jump")
jump_held = Input.is_action_pressed("jump")
dash_pressed = Input.is_action_just_pressed("dash")
holding_down = Input.is_action_pressed("down")
```

These booleans are passed directly to the other components that need them.

### 2. GravityComponent

Applies gravity by checking whether the body is on the floor and adding the appropriate
velocity. Gravity strength is a constant defined in `GameConstants`. Also handles a faster
descent speed when the `down` key is held.

### 3. MovementComponent

Handles horizontal movement through `handle_horizontal_movement()`, using the passed direction
parameter to set the character's velocity.

### 4. JumpComponent

Handles regular and air jumps using an air-jump multiplier and the `want_to_jump` boolean.
Could arguably live inside `MovementComponent`, but kept separate in case more jump-related
features get added later.

### 5. DashComponent

Dash uses a timer for the cooldown plus simple float values for duration and speed, both
adjustable from the inspector on the dash node. Dashing also grants a short invincibility
window that lets the player pass through enemies.

The dash checks which direction the character is facing, accelerates them in that direction,
then starts the cooldown timer and invincibility window:

```gdscript
body.set_collision_layer_value(PLAYER_LAYER, false)
body.set_collision_layer_value(INVINCIBLE_LAYER, true)
body.set_collision_mask_value(ENEMY_LAYER, false)
```

The same logic is reversed once the invincibility window ends.

### 6. AnimationComponent

Requires an `AnimationPlayer` and `Sprite2D` node assigned via the exported variables. Plays
animations and handles character flipping.

**Possible improvement**<br>
Right now this checks things like `player.is_on_floor()` directly instead of relying on
booleans from the other components. Adding something like an `is_moving` variable to
`MovementComponent` and reading that instead of raw input would be cleaner — though that line
of thinking pulls me right back toward a state machine, which is exactly what I was trying to
avoid here.

## Devlog / Design Notes

I've gone through a few different approaches while building this:

1. Started with rough, "scuffed" movement since I didn't know anything about game architecture yet.
2. Learned about state machines and rebuilt movement around them. Got a lot of features working, but logic and important variables ended up spread across many different states, which became hard to maintain.
3. Rebuilt the state machine, then changed direction again partway through and moved to a modular component approach instead.
4. In hindsight, I leaned too hard into stuffing everything into states during the state-machine version — the functionality could have been split up better than it was.

State machines genuinely seem better suited for movement than the modular approach turned out
to be, so the current plan is: state machines for enemies, and keep the simpler component
setup for the player for as long as it holds up. This might turn out to be the wrong call, but
it's the current direction.
