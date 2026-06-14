# DEVOLOPMENT DOCUMENTATION
## THOUGHTS
I've been developing different systems for a game. I first started with scuffed movements since I knew nothing about game architecture. I later found out what state machines were and got into that. It was a headache but I got it running and developed a lot of features, however, it soon became very hard to maintain since a lot of the logic and important variables got eventually spread out through different states and it got very messy. This is why I decided to rebuild the state machine. However, after rebuilding the state machine and a few state I once again changed my mind and went the modular road.

This is a lot simpler but yet again i've realized that I might be stupid and stacked everything into states when developing the state machine. I could have divided the functionalites a lot better than I did. State machines are in fact a lot better when it comes to movement, so I decided that I would create state machines for the enemies and keep the simple components for the player movements as long as I can. I just know this is a huge mistake but fuck it we ball.
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

## 6. AnimationComponent
For this component to work you need to add the `AnimationPlayer`- and `Sprite2D`-node into the exported variables.
This component plays animations and handles character flips.

**NOTE**<br>
This whole function could be improved by using the actual booleans to check if the player is on the ground or what not, instead of manually checking if player.is_on_floor. I could add `is_moving` variable to movement component and use that instead of input. However this kind of thinking is taking me back to a state machine GHAAAAAA (I wanted to avoid this)


