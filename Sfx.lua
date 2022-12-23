battleBGM = love.audio.newSource("audio/battle.wav", "static")
battleBGM:setVolume(0.5)

attacksfx = love.audio.newSource("audio/attacksfx.wav", "static")
critsfx = love.audio.newSource("audio/critsfx.wav", "static")
anticritsfx = love.audio.newSource("audio/anticritsfx.wav", "static")
misssfx = love.audio.newSource("audio/misssfx.wav", "static")
buffsfx = love.audio.newSource("audio/buffsfx.wav", "static")
debuffsfx = love.audio.newSource("audio/debuffsfx.wav", "static")
recruitsfx = love.audio.newSource("audio/recruitsfx.wav", "static")
healsfx = love.audio.newSource("audio/healsfx.wav", "static")
clicksfx = love.audio.newSource("audio/clicksfx.wav", "static")

function BGM(gameState)   
    if not battleBGM:isPlaying() then
        love.audio.play(battleBGM)
    end
    return
end

function SFX(gameState)

    if gameState.phase == "CPUSWITCH" then -- on cpuswitch play cry once
        if playSFX then        
            love.audio.play(cpuParty[cpuLead].cry)
        end
    end

    if gameState.phase == "PLAYERSWITCH" then -- on playerswitch play cry once
        if playSFX then        
            love.audio.play(playerParty[playerLead].cry)
        end
    end

    if gameState.phase == "FAINT" then
        if playSFX then
            love.audio.play(Opponent.cry)
        end
    end

    if gameState.message == "ATTACK" or gameState.message == "CPUATTACK" then
        if playSFX then
            love.audio.play(attacksfx)
        end
    end

    if gameState.message == "SUPER EFFECTIVE!" then
        if playSFX then        
            love.audio.play(critsfx)
        end
    end

    if gameState.message == "not very effective..." then
        if playSFX then        
            love.audio.play(anticritsfx)
        end
    end

    if gameState.message == "MISS" or gameState.message == "RISKY" then
        if playSFX then        
            love.audio.play(misssfx)
        end
    end

    if gameState.message == "BUFF" then
        if playSFX then        
            love.audio.play(buffsfx)
        end
    end

    if gameState.message == "DEBUFF" then
        if playSFX then        
            love.audio.play(debuffsfx)
        end
    end

    if gameState.message == "RECRUIT" then
        if playSFX then        
            love.audio.play(recruitsfx)
        end
    end

    if gameState.message == "HEAL" then
        if playSFX then        
            love.audio.play(healsfx)
        end
    end

    if gameState.message == "TRADEOFF" then
        if playSFX then        
            love.audio.play(debuffsfx)
            love.audio.play(buffsfx)
        end
    end

    playSFX = false
    return
end