
local function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2) -- check collisions function 
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function check_player_collision()
	-- finds the chunk the player is in 
	local colliding = false 
	local obj = nil
	local p_chunk = nil 
	for i = 1,#map.main_tiles do 
		local range = {map.main_tiles[i].offset-50,map.main_tiles[i].offset+400}
		if player.x >= range[1] and player.x <= range[2] then 
			p_chunk = i  
		end 
	end 
	
	local x1 = player.x 
	local w1 = player.w
	local h1 = player.h
	local y1 = player.y
	for i = -1,1 do
		for x = 1,8 do 
			for y = 1,21 do 
				if p_chunk ~= nil then 
					local block = nil
					pcall(function() block = map.main_tiles[p_chunk+i][x][y] or map.main_tiles[p_chunk][x][y] or nil end)
					if block ~= nil and block.cancollide == true then 
						local x2 = block.x 
						local w2 = block.width
						local y2 = block.y 
						local h2 = block.height
						if x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1 then 
							colliding = true 
							obj = block
							break
						end
					end
				end
			end
		end
	end
		-- check if he is colliding with any objects that arent below him 
		--return the check 
	return colliding,obj
end
function love.load()
	monitor = require("libs/resources")
	load_time = love.timer.getTime()
	map = require("libs/map")
	player = require("libs/player")
	aspect = require("libs/AspectRatio")
	audio = require("libs/audioplayer")
	moonshine = require("moonshine")
	level = require("libs/level")
	p_chunk = nil 
	big_font = love.graphics.newFont(32)
	small_font = love.graphics.newFont(18)
	paused_width = big_font:getWidth("PAUSED")/2
	scale = 1 -- game draw scale 
	yoff = 0 -- y draw offset 
	shader = moonshine(moonshine.effects.crt)
	.chain(moonshine.effects.scanlines)
	shader.scanlines.width = 1
	shader.scanlines.opacity = 0.6
	audio:load_tracks()
	local w,h = love.graphics.getDimensions()
	aspect:init(w,h,1920,1080) -- 1920x1080 is the games default resolution
	keys_pressed = {} 
	game_screen = love.graphics.newCanvas(aspect.dig_w, aspect.dig_h)
	jumped = false 
	jump_timer = 0 
	level = map.convert_to_chunk(level)
	map.main_tiles = level
	map.chunks_in_focus = {1} -- These are the current chunks being rendered by the GPU, when a player is introduced this will be updated in love.update 
	paused = false
	love.graphics.setLineWidth(4)
	load_time = love.timer.getTime() - load_time
	print(load_time)
end

function love.resize(w,h) -- This function refreshes the automatic scaling whenever the games window is resized. 
	aspect:init(w,h,1920,1080)
	shader = moonshine(moonshine.effects.crt)
	.chain(moonshine.effects.scanlines)
	shader.scanlines.width = 1
	shader.scanlines.opacity = 0.6
	yoff = love.graphics.getHeight() - (love.graphics.getHeight() * scale)
end

function love.keypressed(key) 
	if key:lower() == "a" or key:lower() == "d" then 
		table.insert(keys_pressed,key:lower())
	elseif key:lower() == "w" and player.falling == false and jump_timer == 0 and paused == false then
		jumped = true 
		jump_timer = 1 
	elseif key:lower() == "r" then player.x = 50 player.y = 920

	elseif key:lower() == "x" then 
		if scale == 1 then
			scale = 1.6
			yoff = love.graphics.getHeight() - (love.graphics.getHeight() * scale)
		else 
			scale = 1 
			yoff = 0 
		end 
	elseif key:lower() == "escape" or key:lower() == "p" then 
		paused = not paused
	end
end 

function love.keyreleased(key)
	if key:lower() == "a" or key:lower() == "d" then 
		for i,v in pairs(keys_pressed) do 
			if key:lower() == v then 
				table.remove(keys_pressed,i)
			end
		end
	end
end

function game_update(dt) -- main game simulation 
-- Render distance 
	local p_changed = false 
	for i = 1,#map.main_tiles do 
		local range = {map.main_tiles[i].offset-25,map.main_tiles[i].offset+400}
		if player.x >= range[1] and player.x <= range[2] then 
			if i ~= p_chunk then 
				local chunk_type = nil 
				if p_chunk ~= nil then chunk_type = map.main_tiles[p_chunk].chunk_type end 
				p_chunk = i
				p_changed = true   
				if chunk_type ~= nil then 
					if chunk_type ~= map.main_tiles[p_chunk].chunk_type then 
						chunk_type = map.main_tiles[p_chunk].chunk_type
						if chunk_type == "woods" then 
							audio:fade_to(audio.track_woods)
						elseif chunk_type == "stone" then 
							audio:fade_to(audio.track_stone)
						end 
					end
				end
			end
		end 
	end 
	if p_changed == true then 
		map.chunks_in_focus = {p_chunk-2,p_chunk-1,p_chunk,p_chunk+1,p_chunk+2}
		p_changed = false 
	end
	audio:update(dt)
	--
	--Velocity math for player 
	local pressing_d = false
	local pressing_a = false 
	for i,v in pairs(keys_pressed) do 
		if v == "a" then 
			player:add_velocity(-0.16)
			pressing_a = true 
		elseif v == "d" then 
			player:add_velocity(0.16)
			pressing_d = true 
		end
	end
	if player.velocity > 0 and pressing_d == false then 
		player.velocity = player.velocity - 0.16
		if player.velocity < 0 then player.velocity = 0 end 
	end 
	if player.velocity < 0 and pressing_a == false then 
		player.velocity = player.velocity + 0.16 
		if player.velocity > 0 then player.velocity = 0 end 
	end 
	--
	--Deciding if player moves 
	player.x = player.x + player.velocity 
	local col,obj = check_player_collision()
	if col ~= true then
	else
		player.x = player.x - player.velocity 
		player.velocity = 0
	end 
	--
	--falling physics 
	if player.falling == true and player.grounded == false then 
		player.y_velocity = player.y_velocity + 0.3
		if player.y_velocity >= player.max_velocity*3 then player.y_velocity = player.max_velocity*3 end 
		player.y = player.y + player.y_velocity 
		col,obj = check_player_collision() 
		if col == true then 
			player.y_velocity = 0 
			player.y = obj.y - player.h
			player.falling = false 
			player.grounded = true 
		end
	end

	if player.falling == false and player.grounded == true then 
		player.y = player.y + 1 
		col,obj = check_player_collision() 
		if col ~= true then 
			player.falling = true 
			player.grounded = false 
		else 
			player.y = player.y - 1 
		end
	end
	--
	--jumping physics 

	if jumped == true then 
		jumped = false 
		jump_timer = 20
	end 

	if jump_timer == 20 then 
		player.y_velocity = -10 
		jump_timer = jump_timer - 1 
	end 

	if jump_timer > 0 then -- jumping physics 
		player.y = player.y + player.y_velocity 
		local col,ob = check_player_collision() 
		if col == true and ob.cancollide == true then 
			player.y = player.y - player.y_velocity
		 	player.y_velocity = 0 
		 	jump_timer = 0 
		 	player.falling = true 
		 else 
		 	jump_timer = jump_timer - 1 
		 	if jump_timer == 0 then player.falling = true player.grounded = false end 
		 end
	end
end

function love.update(dt)
	if paused == false  then
		game_update(dt)
	end
	--rendering results 
	love.graphics.translate((player.x*-1) + 100,0)
	game_screen:renderTo(function()
		love.graphics.clear(0.18,0.08,0.25)
		love.graphics.setColor(1,1,1)
		map.draw_chunks()
		player:draw()
	end)
	love.graphics.origin()
	--
	monitor.update(dt)
end

function love.draw(dt)
	love.graphics.setColor(1,1,1)
	
	shader(function()
		love.graphics.draw(game_screen,aspect.x,aspect.y+yoff,0,aspect.scale*scale) -- the 120 offset on the Y axis is so the floor level is more appropriate for the viewer, as a player is introduced this will likely change. 
		if paused == true then 
			love.graphics.setColor(0.1,0.1,0.1,0.7)
			love.graphics.rectangle("fill",0,0,love.graphics.getDimensions())
			love.graphics.setColor(1,1,1)
			love.graphics.setFont(big_font)
			love.graphics.print("PAUSED",(love.graphics.getWidth()/2)-paused_width,240)
		end
	end)
	love.graphics.setColor(1,1,1)
	love.graphics.setFont(small_font)
	monitor.draw()
	
end