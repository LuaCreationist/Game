local audio = {} 

function audio:load_tracks()
	audio.track = love.audio.newSource("music/CalmNight.mp3","static")
	audio.track:setLooping(true)
end
function audio:play() 
	audio.track:play()
end

return audio 