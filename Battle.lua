-- Initialize player and computer stats for first monster in party
playerCombat = {
    DMG = 0,
    ATK = 1,
    DEF = 1,
    SPD = 1
}

cpuCombat = {
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

function resetCombat(table)
        table.DMG = 0
        table.ATK = 1
        table.DEF = 1
        table.SPD = 1
    return table
end 

function calcBuff(gameState, entry, table)
    math.randomseed(os.time())
    hit = math.random()

    if hit <= entry.parameters.hitRate then
        table.ATK = table.ATK * entry.parameters.ATK 
        table.DEF = table.DEF * entry.parameters.DEF
        table.SPD = table.SPD * entry.parameters.SPD
       
        if entry.TYPE == "BUFF" then
            gameState.message = "BUFF" -- NEEDS WORK
        else 
            gameState.message = "DEBUFF"
            print("debug debuff")
        end
        return gameState, table
    else
        gameState.message = "MISS"
        return gameState, table
    end
    return gameState, table
end

function calcAttack(gameState, entry, comb1, stat1, comb2, stat2)
    math.randomseed(os.time())
    hit = math.random()
    hitValue = (entry.parameters.base + stat1.ATK) * entry.parameters.multiplier
    typeBonus = getCounter(entry.TYPE, stat2.TYPE)
    
    if hit <= entry.parameters.hitRate then -- For hits that land
        hitDamage = math.floor((hitValue * typeBonus) - stat2.DEF) -- dmg calc
        
        if typeBonus == 1.25 then 
            gameState.message = "SUPER EFFECTIVE!"
        end

        if typeBonus == 0.8 then
            gameState.message = "NOT VERY EFFECTIVE..."
        end

        if hitDamage > 0 then
            comb2.DMG = comb2.DMG + hitDamage

        else -- sets a minimum damage of 1
            comb2.DMG = comb2.DMG + 1
        end

        if comb2.DMG >= Opponent.stats.HP then -- For killing blows
            comb2.DMG = Opponent.stats.HP -- Set damage equal to max HP
            
            gameState.message = "FAINT"
            print("reset combat")

        end

        return gameState, entry, comb1, stat1, comb2, stat2

    else  -- Miss
        gameState.message = "MISS"

        if entry.TYPE == "RISKY" then -- hits self for 12.5% hp 
            comb1.DMG = comb1.DMG + math.floor(Self.stats.HP * 0.125)
            gameState.message = "RISKY"

            if comb1.DMG >= Self.stats.HP then
                comb1.DMG = Self.stats.HP 
                gameState.message = "SELF FAINT" -- change later
            end
        end
        return gameState, entry, comb1, stat1, comb2, stat2
        --print("MISSED") -- TODO: add a miss dialogue scene 
    end
    return gameState, entry, comb1, stat1, comb2, stat2
end

function getCPUmove()
    cpuMoves = {
        cpuParty[cpuLead].moveset.move1, 
        cpuParty[cpuLead].moveset.move2, 
        cpuParty[cpuLead].moveset.move3, 
        cpuParty[cpuLead].moveset.move4
    }
    
    math.randomseed(os.time())
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
