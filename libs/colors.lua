-- Purple, to blue, to green, to orange, to purple, taking 10 seconds to go between each color , which is 600 frames 

local color = {} 
-- purple is 0.18,0.08,0.2
color.current_color = {0,0,0}
color.stage = "purple"
color.counter = 0 -- max 600 
function color:return_color()
	return color.current_color[1], color.current_color[2], color.current_color[3]
end

function color:update()
	color.counter = color.counter + 1 
	if color.stage == "purple" then 
		if color.counter >= 600 then 
			color.stage = "blue"
			color.counter = 0 
		end
end

return color