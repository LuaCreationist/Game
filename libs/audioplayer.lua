local audio = {} 
local fade_time = 1.5 -- in milliseconds, how long does it take to fade from one track to another 
local current_fade_time  = 1.5
local fading_direction = nil -- true for up, false for down, nil for neither. 
local fading = false 
local fading_to = nil 
audio.currently_playing = nil 

function audio:load_tracks()
	audio.track_back = love.audio.newSource("music/Pill Guts.wav","static")
	audio.track_back:setVolume(1)
	audio.track_back:play()
	audio.track_back:setLooping(true)
	audio.track_base = love.audio.newSource("music/Pill Guts.wav","stream")
	audio.track_base:setLooping(true)
	audio.track_stone = love.audio.newSource("music/Pill Guts.wav","stream")
	audio.track_stone:setLooping(true)
	audio.track_woods = love.audio.newSource("music/Pill Guy.wav","stream")
	audio.track_woods:setLooping(true)
	audio.currently_playing = audio.track_base
	audio.currently_playing:play()
end

function audio:fade_to(track) -- determine whether tracks are fading 
	current_fade_time = 1.5
	fading = true 
	fading_direction = false 
	fading_to = track 
end

function audio:update(dt)
	if fading == true and fading_direction == false then -- if fading down 
		current_fade_time = current_fade_time - dt -- decrease fade 
		if current_fade_time > 0 then -- if still fading down decrease volume 
			audio.currently_playing:setVolume(current_fade_time)
		elseif current_fade_time <= 0 then -- if done decreasing down 
			audio.currently_playing:pause()
			local time = audio.currently_playing:tell() -- pause song and get current time of it 
			audio.currently_playing = fading_to
			audio.currently_playing:seek(time)
			audio.currently_playing:play() -- change song to other track at same time 
			fading_direction = true -- switch to fading up 
			current_fade_time = 0 --set time to 0 
		end
	elseif fading == true and fading_direction == true then -- if fading up 
		current_fade_time = current_fade_time + dt -- add fade 
		if current_fade_time >= fade_time then -- if done fading up 
			fading = false -- stop fading 
			fading_direction = nil -- set to nil 
			current_fade_time = 1.5 -- reset timer 
			--fading_to = nil
		elseif current_fade_time < fade_time then -- if still fading up 
			audio.currently_playing:setVolume(current_fade_time) -- add volume 
		end 
	end
end 

return audio 