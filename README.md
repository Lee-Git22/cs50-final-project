# Recreating Pokemon Battle
#### Video Demo: https://youtu.be/rM5Jx1yBILk
#### Description: 
This is a 2D pokemon inspired game made using the lua/LOVE2D framework, as a final project for CS50x. The scope of this project is to recreate only the turn based combat gameplay of a gameboy pokemon game to the best of my abilities within a reasonable timeframe (about 10 days) I chose not to incorporate any external libraries and developed my own gamestate managing system to experience firsthand some of the data structure and classes design choices game developers might make, as opposed to designing my game around an existencing structure.

**Gameplay**

The games feature a wide range of modern culture memes/characters/celebrities and your goal is to defeat the computer in a 4 on 4 battle through the use of items and attacks. There are 9 playable characters and 8 usable items that are randomly selected at the start of each game. There are 4 fighter types; Machine, Human, Animal, and Magic. Each fighter has a type with different attacks featuring their own types to create type counter system much like pokemon so feel free to replay and explore different strategies. 

**Gamestate management and Flowchart**

The gameplay flow can be represented via this flowchart. The diamonds represent the `gameState.phase` while the dialogue arrows represent its corresponding `gameState.message`. The rectangles represents the visuals the player sees and interacts with, and the circles represent the calculations done for each round of battle. As the gamestate moves from one phase to the next, it also passes along a message depending on what outcome was produced from the given gamestate inputs. The gamestate manager also keeps track of a `gameState.timer` that runs parallel with the in game timer, and it's manipulated and to diplay messages for the desired duration

Full Flowchart: ![flowchart](/Flow-chart.png). 

**Modules and Custom Files breakdown**

I created 3 separate modules in the modules folder called `AttackModule.lua`, `FightersModule.lua`, and `ItemsModule.lua`. These main purpose of these files is to hold a data table consisting of all the parameters related to attacks, fighters, and items. These datatables are then referenced within `main.lua` and other custom files when needed. These datatables are loaded when the game starts and its values remain static. 

The other custom files each have their own related functions used for a specific aspect of the game. For instance, the `Battle.lua` file consists of all the necessary battle related calculation functions and logic that is called during the battle phase within `main.lua`. I will now briefly go over each of these custom files, along with some design choices within them. 

Inside `Battle.lua`, there are several load functions that are called to set up the initial battle, the player and cpu are given random items and fighters. The `calcAttack()` and `calcBuff()` functions are used during attack phases and return both the outcomes of each round (ie the damage, stat changes) and the relevant `gameState.message` the computer's moves are randomly selected using `getCPUmove()` which just uses a simple pseudoRNG generator and rolls between 1-4. Originally I had planned to have two separate functions for debuff vs buff attacks but I realized I could create two perspective variables `Self` and `Opponent` and call the same buff function in order to apply the modifiers to the right fighters (buffs for `Self` and debuffs for `Oppoent`). Finally there is a `resetCombat()` function that just resets the combat parameters whenever a fighter faints, as it not have its damage, buffs, or debuffs carrying over. 

The `Menu.lua` file handles all graphical displays for the dialogue boxes, along with the interactive buttons for the player. Each time a new `gameState.message` is passed through the `loadDialogue()` function, a message will display in the bottom of the screen for a specified amount of time. I find that there was a tricky balance for deciding how robust and template heavy a message can be as to reduce the number of cases I need to implement, versus how customized each message should be to give the player more information. I decided that the `loadDialogue()` function will take in at most 3 parameters, the `gameState`, `monsterName`, and `input`. Which I feel provides good enough information without going overboard with the number of parameters each message must receive

The `UI.lua` file simply loads in the correct sprites and interacts with `gameState.phase` to ensure the correct sprites are loaded. 

The `Sfx.lua` file handles all the sfx used in this game, as well as the BGM. I had implemented this feature towards the end of the development and to my surprise it was very easy to play each specific sfx at the right time since I linked it to a corresponding `gameState.message` value. Which goes to show having a slightly verbose gameState manager with lots of steps inbetween each phase can be helpful for adding or targeting events at specific timings of the game. 

Finally inside the `conf.lua` is simply just a parameter for the game title, and also some minor optimization as the game can be played with only the mouse.

**Summary and Future Improvements**

Overall I am quite proud of what I was able to produce, and I felt I learned a lot on the basics of OOP while working on this project. That being said, the gamestate manager and the custom lua files turned out to be much more verbose than needed, mainly due to my inexperience with the language. As the gameState.phase and gameState.message were used so frequently in pairs, it might make more sense have gameState.message as a child class for the gameState.phase. I also felt like I was repeating a lot of the same code for player and cpu phases, perhaps with some clever coding (and more time) I could merge the two into a series of robust generalized methods and have either the player or cpu object to call them. 

Other more aesthetic or QoL features I would want to include in the future or if I were to make another version would be a fighter select screen so players could choose their own fighers, special attacks with special buffs/debuffs properties attached them and various other animations and ui assets to really bring the game to life. 

##### Resources Used
BGM and SFX - Pokemon RBY Sound library

Sprites - Partly created using [Pixel It](https://giventofly.github.io/pixelit/) by giventofly 