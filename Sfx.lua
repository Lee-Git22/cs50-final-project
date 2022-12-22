test = love.audio.newSource("audio/thor.mp3", "static")

function BGM()
    if not test:isPlaying() then
        love.audio.play(test)
    end
    return

    
end