local audio = {} 

function audio:load_tracks()
	audio.track = love.audio.newSource("music/Pill Guts.wav","static")
	audio.track:setLooping(true)
end
function audio:play() 
	audio.track:play()
end

return audio 