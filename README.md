# Modern Culture Battle - a LOVE2D Pokemon inspired game 
#### Video Demo: 
#### Description: 
This is a 2D pokemon inspired game made using the lua/LOVE2D framework, as a final project for CS50x. The scope of this project is to recreate only the turn based combat gameplay of a gameboy pokemon game to the best of my abilities within a reasonable timeframe (about 10 days) I chose not to incorporate any external libraries and developed my own gamestate managing system to experience firsthand some of the data structure and classes design choices game developers might make, as opposed to designing my game around an existencing structure.

### Gameplay
The games feature a wide range of modern culture memes/characters/celebrities and your goal is to defeat the computer in a 4 on 4 battle through the use of items and attacks. There are 9 playable characters and 8 usable items that are randomly selected on start up. There are 4 fighter types; Machine, Human, Animal, and Magic. Each fighter has a type with different attacks featuring their own types to create type counter system much like pokemon so feel free to replay and explore different strategies. 

### Gamestate management and Flowchart
The gameplay flow can be represented via this flowchart *link*. The diamonds represent the gameState.phase while the dialogue arrows represent its corresponing gameState.message. The rectangles represents the visuals the player sees and interacts with, and the circles represent the calculations done for each round of battle. As the gamestate moves from one phase to the next, it also passes along a gamestate message depending on what outcome was produced from the given gamestate inputs. The gamestate manager also keeps track of a timer that runs parallel with the in game timer, and it's manipulated and to diplay messages for the desired duration
