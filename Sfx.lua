battleBGM = love.audio.newSource("audio/battle.wav", "static")
battleBGM:setVolume(0.5)

clicksfx = love.audio.newSource("audio/clicksfx.wav", "static")
clicksfx:setVolume(0.5)

attacksfx = love.audio.newSource("audio/attacksfx.wav", "static")
critsfx = love.audio.newSource("audio/critsfx.wav", "static")
anticritsfx = love.audio.newSource("audio/anticritsfx.wav", "static")
misssfx = love.audio.newSource("audio/misssfx.wav", "static")
buffsfx = love.audio.newSource("audio/buffsfx.wav", "static")
debuffsfx = love.audio.newSource("audio/debuffsfx.wav", "static")
recruitsfx = love.audio.newSource("audio/recruitsfx.wav", "static")
healsfx = love.audio.newSource("audio/healsfx.wav", "static")

function BGM(gameState)   
    if not battleBGM:isPlaying() then
        love.audio.play(battleBGM)
    end
    return
end

-- Plays corresponding gameState SFX once 
function SFX(gameState)
    if playSFX then
        if gameState.phase == "CPUSWITCH" then 
            love.audio.play(cpuParty[cpuLead].cry)
        end
    
        if gameState.phase == "PLAYERSWITCH" then 
            love.audio.play(playerParty[playerLead].cry)
        end
    
        if gameState.phase == "FAINT" then
            love.audio.play(Opponent.cry)
        end
    
        if gameState.message == "ATTACK" or gameState.message == "CPUATTACK" then
            love.audio.play(attacksfx)
        end
    
        if gameState.message == "SUPER EFFECTIVE!" then
            love.audio.play(critsfx)
        end
    
        if gameState.message == "not very effective..." then
            love.audio.play(anticritsfx)
        end
    
        if gameState.message == "MISS" or gameState.message == "RISKY" then
            love.audio.play(misssfx)
        end
    
        if gameState.message == "BUFF" then
            love.audio.play(buffsfx)
        end
    
        if gameState.message == "DEBUFF" then
            love.audio.play(debuffsfx)
        end
    
        if gameState.message == "RECRUIT" then
            love.audio.play(recruitsfx)
        end
    
        if gameState.message == "HEAL" then
            love.audio.play(healsfx)
        end
    
        if gameState.message == "TRADEOFF" then
            love.audio.play(debuffsfx)
            love.audio.play(buffsfx)
        end
    end

    playSFX = false
    return
end