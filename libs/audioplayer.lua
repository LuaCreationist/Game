local audio = {} 

function audio:load_tracks()
	audio.track_stone = love.audio.newSource("music/Pill Guts.wav","stream")
	audio.track_stone:setLooping(true)
	audio.track_woods = love.audio.newSource("music/Pill Guy.wav","stream")
	audio.track_woods:setLooping(true)
end

return audio 