-- Initialize player and computer stats for first monster in party
playerCombat = { 
    DMG = 0, -- Total damage the fighter is currently sustaining
    ATK = 1, -- Buff/Debuff multipliers
    DEF = 1,
    SPD = 1
}
cpuCombat = {
    DMG = 0,
    ATK = 1,
    DEF = 1,
    SPD = 1
}
itemBonus = {
    ATK = 0, -- Flat Increase/decrease from items
    DEF = 0,
    SPD = 0
}
-- Loads in 4 monsters for both trainers
function loadPlayerParty()
    playerPartySize = 4
    
    local p1 = math.random(1,9)
    math.randomseed(love.mouse.getPosition()) -- for better RNG
    local p2 = math.random(1,9)
    math.randomseed(os.time()-love.mouse.getPosition())
    local p3 = math.random(1,5)
    local p4 = math.random(4,9)
    
    -- For go using a loop to have more variety due to pseudo RNG limitations
    table.insert(playerParty, FightersIndex[p4])
    table.insert(playerParty, FightersIndex[p3])
    table.insert(playerParty, FightersIndex[p2])
    table.insert(playerParty, FightersIndex[p1])
    
    playerLead = 1 
    return
end
function loadCpuParty()
    cpuPartySize = 4

    local p1 = math.random(1,9)
    math.randomseed(love.mouse.getPosition()) 
    local p2 = math.random(1,9)
    math.randomseed(os.time()-love.mouse.getPosition())
    local p3 = math.random(1,5)
    local p4 = math.random(4,9)

    table.insert(cpuParty, FightersIndex[p1])
    table.insert(cpuParty, FightersIndex[p2])
    table.insert(cpuParty, FightersIndex[p3])
    table.insert(cpuParty, FightersIndex[p4])

    cpuLead = 1
    return
end

function addItem(name, uses)
    return {
        name = name,
        uses = uses
    }
end

-- Initialize player inventory 
Inventory = {}
function loadInventory(Inventory)
    -- Player gets 2 random powerful pool1 items and random amounts of pool2 items
    item1 = table.insert(Inventory, addItem(ItemDatabase[math.random(1,2)].name, 1)) -- powerful items
    item2 = table.insert(Inventory, addItem(ItemDatabase[math.random(3,4)].name, 2)) -- powerful items
    item3 = table.insert(Inventory, addItem(ItemDatabase[math.random(4,6)].name, math.random(2,4)))
    item4 = table.insert(Inventory, addItem(ItemDatabase[math.random(6,8)].name, math.random(2,4)))
    
    return Inventory
end

-- Reduce DMG based on healValue and display message
function Heal(DMG, healValue)
    DMG = DMG - healValue 
    recovered = healValue
    if DMG < 0 then
        recovered = healValue + DMG -- Determines actual amount if over healed
        DMG = 0 -- Prevents overhealing
    end
    
    gameState.message = "HEAL"
    return DMG
end

-- Adds number amount of monsters into party and display message
function Recruit(value) 
    addedNames = {}
    for i = 1,value,1
    do
        local tmp = math.random(1,9)
        table.insert(playerParty, FightersIndex[tmp])
        table.insert(addedNames, FightersIndex[tmp].name) 
    end
    playerPartySize = playerPartySize + value
    gameState.message = "RECRUIT"
end

-- Decreases 1 stat and increases another based on item used
function Tradeoff(stat1, stat2, value1, value2)
    stat1 = stat1 - value1
    stat2 = stat2 + value2

    negtrade = value1 
    postrade = value2
    gameState.message = "TRADEOFF"
    return math.floor(stat1), math.floor(stat2)
end

-- Used to determine type bonuses in battle calculations
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

-- Used to reset combat stats for new fighter
function resetCombat(table)
        table.DMG = 0
        table.ATK = 1
        table.DEF = 1
        table.SPD = 1
    return table
end 

-- Determines if a buff or debuff attack was successful, and manipulates stats accordingly
function calcBuff(gameState, entry, table)
    math.randomseed(os.time()-love.mouse.getPosition())
    hit = math.random()

    if hit <= entry.parameters.hitRate then
        table.ATK = table.ATK * entry.parameters.ATK 
        table.DEF = table.DEF * entry.parameters.DEF
        table.SPD = table.SPD * entry.parameters.SPD
       
        if entry.TYPE == "BUFF" then
            gameState.message = "BUFF" 
        else 
            gameState.message = "DEBUFF"
        end
        return gameState, table
    else
        gameState.message = "MISS"
        return gameState, table
    end
    return gameState, table
end

-- Handles battle calculations for attacks
function calcAttack(gameState, entry, comb1, stat1, comb2, stat2)
    math.randomseed(os.time()-love.mouse.getPosition())
    hit = math.random()
    hitValue = (entry.parameters.base + stat1.ATK) * entry.parameters.multiplier
    typeBonus = getCounter(entry.TYPE, stat2.TYPE)
    
    if hit <= entry.parameters.hitRate then -- For hits that land
        hitDamage = math.floor((hitValue * typeBonus) - stat2.DEF) -- dmg calc
        
        if typeBonus == 1.25 then 
            gameState.message = "SUPER EFFECTIVE!"
        end
        if typeBonus == 0.8 then
            gameState.message = "not very effective..."
        end

        if hitDamage > 0 then
            comb2.DMG = comb2.DMG + hitDamage

        else -- sets a minimum damage of 1
            comb2.DMG = comb2.DMG + 1
        end

        if comb2.DMG >= Opponent.stats.HP then -- For killing blows
            comb2.DMG = Opponent.stats.HP -- Set damage equal to max HP to prevent overkill DMG
            gameState.message = "FAINT"
        end

        return gameState, entry, comb1, stat1, comb2, stat2

    else  -- Miss
        gameState.message = "MISS"
        if entry.TYPE == "RISKY" then -- hits self for 12.5% hp 
            comb1.DMG = comb1.DMG + math.floor(Self.stats.HP * 0.125)
            gameState.message = "RISKY"

            if comb1.DMG >= Self.stats.HP then -- Prevents RISKY hits from fainting itself
                comb1.DMG = Self.stats.HP - 1
                gameState.message = "RISKY" 
            end
        end
        
        return gameState, entry, comb1, stat1, comb2, stat2
    
    end
    return gameState, entry, comb1, stat1, comb2, stat2
end

-- Randomly selects a CPU move, cpu can not use items
function getCPUmove()
    -- Loads available moves for current cpu fighter
    cpuMoves = {
        cpuParty[cpuLead].moveset.move1, 
        cpuParty[cpuLead].moveset.move2, 
        cpuParty[cpuLead].moveset.move3, 
        cpuParty[cpuLead].moveset.move4
    }
    
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
