-- I am the Garbage Man --
local gm = {}
local time_elapsed = 0.0 -- Time since garbage collect was needed (Seconds)
local data_collected = 0.0 -- MB's of data cleared from ram
local currently_using = 0 -- Percent of ram we are using out of whats available

local output_timer = 0.0

function collect(v)
	local before_collect = collectgarbage("count")
	collectgarbage()
	local new_count = collectgarbage("count")
	data_collected = before_collect - new_count
	currently_using = new_count/1024
end

function output(v)
	output_timer = output_timer + v
	if output_timer >= 0.5 then
		output_timer = 0.0
		local percent = string.sub(tostring(((currently_using / 2048) * 100 )),0,4)
		local text = "Hey, Garbage Man Here : \n Time since the last auto collect is "..string.sub(tostring(time_elapsed),0,3).."\n".."We collected "..string.sub(tostring(data_collected),0,6).." Kilobytes of data in that run \nNow you're using "..string.sub(tostring(currently_using),0,4).." Megabytes of ram, FPS looks good still yeah? \n You've used "..percent.."% of your Ram Resources\n"

		print(text)
	end
end

function gm.update(dt)
	if love.timer.getFPS() <= 120 then
		time_elapsed = 0.0
		collect(dt)
	else
		time_elapsed = time_elapsed + dt
		currently_using = collectgarbage("count")/1024
	end
	output(dt)
end

return gm
