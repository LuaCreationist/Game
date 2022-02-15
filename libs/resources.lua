--Resource monitoring 
local monitor = {} 
--Unit:MB
monitor.memory_used = 0 -- script memory being used by Lua (Unit:)
monitor.objects_rendered = 0 
monitor.light_sources = 0 
monitor.draw_calls = 0  -- Number of draw calls made in a frame
monitor.texture_memory = 0  -- VRam being used (Unit:)
monitor.shader_switches = 0
monitor.ms = 0 -- Delta time 
monitor.images_loaded = 0 -- number of images loaded 

local Str = string.sub
local Tostr = tostring
local Coll = collectgarbage

local timer = 0 
local timer_max = 60 
local FPS = 0
local function get_stats() -- update variables 
	monitor.memory_used = Str(Tostr(Coll("count")/1024),0,5)
	local stats = love.graphics.getStats()
	monitor.draw_calls = stats.drawcalls
	monitor.texture_memory = stats.texturememory/1024/1024
	monitor.shader_switches = stats.shaderswitches
	monitor.images_loaded = stats.images 
	stats = nil 
end

monitor.update = function(dt)
	FPS = 1/dt
	timer = timer + 1 
	if timer >= timer_max then 
		timer = 0 
		get_stats()
		monitor.ms = Str(Tostr(dt*1000),0,5)
	end
end

monitor.draw = function() 
	love.graphics.print("FPS: "..FPS,10,10)
	love.graphics.print("MS: "..monitor.ms,10,30)
	love.graphics.print("Script Memory(KB): "..monitor.memory_used,10,50)
	love.graphics.print("Texture Memory(MB): "..monitor.texture_memory,10,70)
	love.graphics.print("Draw Calls: "..monitor.draw_calls,10,90)
	love.graphics.print("Images Loaded: "..monitor.images_loaded,10,110)
	love.graphics.print("Shader Switches: "..monitor.shader_switches,10,130)
	love.graphics.print("Light Sources: "..monitor.light_sources,10,150)
	love.graphics.print("Objects Rendered: "..monitor.objects_rendered,10,170)
end

return monitor 