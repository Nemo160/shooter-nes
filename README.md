# DEVOLOPMENT DOCUMENTATION

# PLAYER MOVEMENT
## Modular Components 
This game handles player movement with modular components. The `Player` class functions as a middleman for each component. This class calls the engines physics functions every frame, which lets every component communicate and handle their respective input. Separating the functionallity in this manner improves the projects scaleability and code readability.

Every component variable is exported to the inspector with the name "Nodes"

**LATER NOTE**<br>
Every component connect through Player, however, I've come to realize that this also means that every component has access to an instance of each component through player. This basically means that you can call GravityComponent variables and functions in JumpComponent. This works because the Player instance is passed to every component. **DO NOT** use this! I assume that the instance that is used when accessing variables this way could be outdated or even worse it could lead to a recursive black hole if not careful.

## Components
### 1. InputComponent
This component handles the user inputs with a single function `update_input()` by setting the corresponding boolean to either true or false depening if their respective key has been pressed.
```
input_horizontal = Input.get_axi("left", "right")
jump_pressed = Input.is_action_just_pressed("jump")
jump_held = Input.is_action_pressed("jump")
dash_pressed = Input.is_action_just_pressed("dash")
holding_down = Input.is_action_pressed("down")
```
Input returns true if the key is being pressed. This is used to set the declared booleans. These booleans are later passed directly to other components .

### 2. GravityComponent
This handles the gravity by simply checking if the body that is being passed is on the floor and then adding suitable velocity. The gravity is a constant set in `GameConstant`.

This component also handles descending speed by checking if the `down`key is being pressed (passed parameter).

### 3. MovementComponent
The movement horizontal movement is handled in the function `handle_horizontal_movement()`. The function uses the passed direction parameter to set the correct character velocity.

### 4. JumpComponent
Not sure if this should be handled by the movement component, but I chose to make it a separate component incase anything else is added.

`JumpComponent` handles jump and air jump by having a air jump multiplier and checking the `want_to_jump` boolean.

## 5. DashComponent
The dash functionality uses a timer for the cooldown and a simple float value for the dash duration, and speed. Duration and speed can be changed with the inspector tool in the dash node. The dash also gives the player an invincibility window that allows them to walk through enemies. 

The dash is handled by simply checking which direction the character is facing and accelerating them that direction and then starting a timer and invicibility window.

The invicibility functionality is done by disabling when the dash starts and enabling them again when the dash is done. 
```
body.set_collision_layer_value(PLAYER_LAYER, false)
body.set_collision_layer_value(INVINCIBLE_LAYER, true)
body.set_collision_mask_value(ENEMY_LAYER, false)
```
Then the invers is done to end the invincibility window.
