-- Initialize player and computer stats for first monster in party
playerCombat = {
    DMG = 0,
    ATK = 1,
    DEF = 1,
    SPD = 1
}

computerCombat = {
    DMG = 0,
    ATK = 1,
    DEF = 1,
    SPD = 1
}


function getCounter(type1, type2)
    if type1 == "HUMAN" and type2 == "ANIMAL" then
        return 1.25
    elseif type1 == "MACHINE" and type2 == "HUMAN" then
        return 1.25
    elseif type1 == "MAGIC" and type2 == "MACHINE" then
        return 1.25
    elseif type1 == "ANIMAL" and type2 == "MAGIC" then
    elseif type1 == type2 then
        return 0.8
    end
    return 1.0
end

function resetCombat(DMG, ATK, DEF, SPD)
    DMG = 0
    ATK = 0
    DEF = 0
    SPD = 0
    return 
end 

-- tmptmp will be a value passed to UI for displaying messages
function calcBuff(gameState, entry, table)
    hit = math.random()

    if hit <= entry.parameters.hitRate then
        table.ATK = table.ATK * entry.parameters.ATK 
        table.DEF = table.DEF * entry.parameters.DEF
        table.SPD = table.SPD * entry.parameters.SPD
       
        gameState.action = "buff works"
        return gameState, table
    else
        gameState.action = "buff failed"
        return gameState, table
    end
    return gameState, table
end

function calcAttack(gameState, entry, comb1, stat1, comb2, stat2)
    hit = math.random()
    hitValue = (entry.parameters.base + stat1.ATK) * entry.parameters.multiplier
    typeBonus = getCounter(entry.TYPE, stat2.TYPE)
    
    if hit <= entry.parameters.hitRate then -- hitRate is returns a %, if hit calls within that % then attack is performed
        hitDamage = math.floor((hitValue * typeBonus) - stat2.DEF)
        
        if hitDamage > 0 then
            comb2.DMG = comb2.DMG + hitDamage
            
            gameState.action = "SUPER EFFECTIVE"
            
        else -- sets a minimum damage of 1
            comb2.DMG = comb2.DMG + 1
            gameState.action = "SUPER EFFECTIVE"
        end
        return gameState, entry, comb1, stat1, comb2, stat2
        --TODO: Logic for HP hitting 0 
    else 
        if entry.TYPE == "RISKY" then -- hits player back 12.5% hp 
            comb1.DMG = comb1.DMG + math.floor(playerParty[playerLead].stats.HP * 0.125)
            print("missed and hurt itself")
        end
        return gameState, entry, comb1, stat1, comb2, stat2
        --print("MISSED") -- TODO: add a miss dialogue scene
    end
    return gameState, entry, comb1, stat1, comb2, stat2
end

function getCPUmove()
    cpuMoves = {computerParty[computerLead].moveset.move1, computerParty[computerLead].moveset.move2, computerParty[computerLead].moveset.move3, computerParty[computerLead].moveset.move4}
    move = math.random(4)
    if move == 1 then
        return cpuMoves[1]
    elseif move == 2 then
        return cpuMoves[2]
    elseif move == 3 then
        return cpuMoves[3]
    else
        return cpuMoves[4]
    end
end
    -- -- For attacks
    -- hitValue = (entry.parameters.base + playerStats.ATK) * entry.parameters.multiplier
    -- typeBonus = getCounter(entry.TYPE, computerStats.TYPE) -- will be 1 (default) or a 1.25x boost for effective and 0.8x for not effective
    
    
    -- if hit <= entry.parameters.hitRate then -- hitRate is returns a %, if hit calls within that % then attack is performed
    --     hitDamage = math.floor((hitValue * typeBonus) - computerStats.DEF)
        
    --     if hitDamage > 0 then
    --         computerCombat.DMG = computerCombat.DMG + hitDamage
    --     else -- sets a minimum damage of 1
    --         computerCombat.DMG = computerCombat.DMG + 1
    --     end
        
    --     --TODO: Logic for HP hitting 0 
    -- else 
    --     if entry.TYPE == "RISKY" then -- hits player back 12.5% hp 
    --         playerCombat.DMG = playerCombat.DMG + math.floor(playerParty[playerLead].stats.HP * 0.125)
    --         print("missed and hurt itself")
    --     end
        
    --     --print("MISSED") -- TODO: add a miss dialogue scene
    -- end