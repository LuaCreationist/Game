# Right now its kinda just a thing.

There's a good amount going on under the hood, so I'll start documenting that bit by bit I suppose. 

The background is always a static color, and the shaders are provided by moonshine. 

The game client is native 1920x1080, and as you'll notice most objects aside from the player are tiles. 
Each tile is 50x50 and contained within chunks of 8x21. 

The client will scale what it is rendering to whatever resolution you put it to, but this will soon be changed to what resolution setting you choose. 

A camera feature will soon be implemented to follow the player, and be toggleable to the current perspective and a closer one. 

Currently the game will attempt to render the chunk the player is in, infront of, and behind. It handles all exceptions when it cannot. 

All of the players movement is based upon velocity, including the jumping, no collision problems have been found so far. 

The music player simply loops an audio track. 

And the map generation is currently able to handle random generation, though soon I want it to be able to handle built in map files that potentially could be generated from 
another project. 
