battleBGM = love.audio.newSource("audio/battle.mp3", "static")
battleBGM:setVolume(0.5)

-- need a crit hit, not effective hit and normal hit sfx
-- need a sfx for each move type - human, machine,magic, normal, buff, debuff
-- need a sfx for items - recruit and heal/berry 
-- need a sfx for spawning and fainting 

function BGM(gameState)
    
    if not battleBGM:isPlaying() then

        love.audio.play(battleBGM)

    end
    return

end

function SFX(gameState)

    if gameState.phase == "cpuswitch" then -- on cpuswitch play cry once
        if playSFX then        
            love.audio.play(cpuParty[cpuLead].cry)
            playSFX = false
        end
    end

    if gameState.phase == "playerswitch" then -- on playerswitch play cry once
        if playSFX then        
            love.audio.play(playerParty[playerLead].cry)
            playSFX = false
        end
    end

    return
end