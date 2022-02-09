local map = {}
map.chunks_in_focus = {} -- the chunks being rendered by the GPU 
map.main_tiles = {} -- This is the 3D array containing all of the Chunks, which themselves are 2D arrays. Each cell is a chunk.

map.make_entity = function(type) -- This function creates entitys (Any item contained in a chunk) and returns them, used in chunk generation. 
	local ent = {}
	if type == "air" then
		ent.x = nil
		ent.y = nil
		ent.width = 50
		ent.height = 50
		ent.cancollide = false
		ent.transparency = 1
		ent.r = 1
		ent.g = 1
		ent.b = 1
	elseif type == "stone" then
		ent.x = nil
		ent.y = nil
		ent.width = 50
		ent.height = 50
		ent.cancollide = true
		ent.transparency = 0
		ent.r = 0.5
		ent.g = 0.5
		ent.b = 0.5
	end
	return ent
end

map.convert_to_chunk = function(t) -- converts 3D array into useable game chunk with the make_entity command 
	for i = 1,#t do 
		local offset = (i-1) * 400 or 0 
		t[i].offset = offset
		for x = 1,8 do 
			for y = 1,21 do 
				local cell = nil or t[i][x][y] 
				if cell ~= nil then 
					if cell == 0 then
						cell = map.make_entity("air")
					elseif cell == 1 then 
						cell = map.make_entity("stone")
					end
				end
				t[i][x][y] = cell 
				t[i][x][y].x = (x-1) * 50 + offset 
				t[i][x][y].y = 50 * (y-1) 
			end
		end
	end 
	return t 
end

map.generate_chunks = function(amount) -- This is the current automatic chunk generation, currently making all cells air except the bottom layer, which is stone. 
	for i = 1,amount do
		local offset = (i-1) * 400 or 0 
		map.main_tiles[i] = {}
		map.main_tiles[i].offset = offset 
		for x = 0,8 do
			map.main_tiles[i][x] = {}
			for y = 0,21 do
				local d = x 
				if y < 21 then
					map.main_tiles[i][x][y] = map.make_entity("air")
					map.main_tiles[i][x][y].x = d * 50 + offset 
					map.main_tiles[i][x][y].y = 50 * (y)
				else

					map.main_tiles[i][x][y] = map.make_entity("stone")
					map.main_tiles[i][x][y].x = d * 50 + offset 
					map.main_tiles[i][x][y].y = 50 * (y)
				end

			end
		end
	end
end

map.draw_chunks = function() -- This is the function that displays the focused chunks into the GPU
	for v,i in pairs(map.chunks_in_focus) do

		for x = 1,8 do
			for y = 1,21 do
				local block = map.main_tiles[i] and map.main_tiles[i][x] and map.main_tiles[i][x][y] or nil -- Making sure the block exists within the arrays 
				if block and block.transparency ~=1 then -- Checks if the block should be visible 
					love.graphics.setColor(block.r,block.g,block.b)
					local bx,by,bw,bh = map.main_tiles[i][x][y].x,map.main_tiles[i][x][y].y,map.main_tiles[i][x][y].width,map.main_tiles[i][x][y].height
					love.graphics.rectangle("line", bx,by,bw,bh)
					love.graphics.rectangle("line", bx + 4,by + 4,bw - 8,bh - 8)	
				end
			end
		end
		love.graphics.setColor(1,1,1) -- Resetting the display color for any other potential draw commands in the current cycle. 
	end
end

return map
