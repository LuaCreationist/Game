local player = {} 

player.sprite = love.graphics.newImage("sprites/player.png")
player.x = 50 
player.y = 920
player.w = player.sprite:getWidth()
player.h =player.sprite:getHeight()
player.velocity = 0 -- X velocity only 
player.max_velocity = 5.6 -- when comparing only use the absolute value 
player.grounded = false
player.falling = true
player.y_velocity = 0 

function player:add_velocity(v)
	local vel = player.velocity 
	vel = vel + v 
	if math.abs(vel) > player.max_velocity then -- checking if the player would be moving faster than he should be allowed too 
		vel = vel - v 
	end
	player.velocity = vel 
end

function player:move()
	player.x = player.x + player.velocity 
end 

function player:draw() 
	love.graphics.setColor(1,1,1)
	love.graphics.draw(player.sprite,player.x,player.y)
end 
return player 