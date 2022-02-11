# Right now its kinda just a thing.

You're a little pill guy traveling about. Nothing to do quite yet. Prolly, maybe, might be soon. 

Alpha 1.1 - Camera Added. Hit X to Zoom in on the player 
Additional patches : 
 Alpha 1.2-1.12 : 
- Player velocity stick on wall collision has been fixed 
- Map generation has been replaced with premade maps in a separate Lua file, making the size absolutely tiny. 
- These maps have chunks with differentiating chunk types, which may have effects on visuals later in the game. 
- When a player changes their chunk type, the current music track will be switched to the appropriate one 
- All music in the game (Made by Copyright Jeffery Wellman 2022) have the same background track, and loop perfectly
- so when you change biomes, the music changes with it. Soon they will fade out instead of abruptly changing if neccessary. 
- Player render distance increased to 6. 
- Render order has been altered and the render process has been adjusted to reduce translation tear, though it cannot be entirely avoided without the use of VSync as of yet. 
- Player velocity curve adjusted for smoothening.
- Water tile / Grass tile have been added 
- Woods chunk type has been added, default chunk type renamed to Stone 
- Game load time average clocked in at 70 microseconds. 
