

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

itemBonus = {
    ATK = 0,
    DEF = 0,
    SPD = 0
}

function loadPlayerParty()
    -- Loads in 4 monsters for both trainers
    playerPartySize = 4
    
    local p1 = math.random(1,9)
    math.randomseed(love.mouse.getPosition()) -- for better RNG
    local p2 = math.random(1,9)
    math.randomseed(os.time()-love.mouse.getPosition())
    local p3 = math.random(1,5)
    local p4 = math.random(4,9)
    
    -- For go using a loop to have more variety due to pseudo RNG limitations
    table.insert(playerParty, MonstersIndex[p4])
    table.insert(playerParty, MonstersIndex[p3])
    table.insert(playerParty, MonstersIndex[p2])
    table.insert(playerParty, MonstersIndex[p1])
    
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

    table.insert(cpuParty, MonstersIndex[p1])
    table.insert(cpuParty, MonstersIndex[p2])
    table.insert(cpuParty, MonstersIndex[p3])
    table.insert(cpuParty, MonstersIndex[p4])

    cpuLead = 1
    return
end

-- Initialize player inventory 
Inventory = {}
function loadInventory(Inventory)
    -- Player gets 2 random powerful pool1 items and random amounts of pool2 items
    item1 = table.insert(Inventory, addItem(ItemDatabase[math.random(1,2)].name, 1)) -- powerful items
    item2 = table.insert(Inventory, addItem(ItemDatabase[math.random(3,4)].name, 2)) -- powerful items
    item3 = table.insert(Inventory, addItem(ItemDatabase[math.random(5,6)].name, math.random(2,4)))
    item4 = table.insert(Inventory, addItem(ItemDatabase[math.random(7,8)].name, math.random(2,4)))
    
    return Inventory
end

function Heal(DMG, healValue)
    DMG = DMG - healValue -- Reduce DMG based on healValue
    recovered = healValue
    if DMG < 0 then
        recovered = healValue + DMG -- Determines actual amount if over healed
        DMG = 0 -- Prevents overhealing
    end
    
    gameState.message = "HEAL"
    return DMG
end

function Recruit(value) -- Adds number amount of monsters into party
    addedNames = {}
    for i = 1,value,1
    do
        local tmp = math.random(1,9)
        table.insert(playerParty, MonstersIndex[tmp])
        table.insert(addedNames, MonstersIndex[tmp].name) 
    end
    playerPartySize = playerPartySize + value
    gameState.message = "RECRUIT"
end

function Tradeoff(stat1, stat2, value1, value2)
    stat1 = stat1 - value1
    stat2 = stat2 + value2

    negtrade = value1 
    postrade = value2
    gameState.message = "TRADEOFF"
    return math.floor(stat1), math.floor(stat2)
end


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
            comb2.DMG = Opponent.stats.HP -- Set damage equal to max HP
            
            gameState.message = "FAINT"
        end

        return gameState, entry, comb1, stat1, comb2, stat2

    else  -- Miss
        gameState.message = "MISS"

        if entry.TYPE == "RISKY" then -- hits self for 12.5% hp 
            comb1.DMG = comb1.DMG + math.floor(Self.stats.HP * 0.125)
            gameState.message = "RISKY"

            if comb1.DMG >= Self.stats.HP then
                comb1.DMG = Self.stats.HP - 1
                gameState.message = "RISKY" 
            end
        end
        return gameState, entry, comb1, stat1, comb2, stat2
    
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
    
    --math.randomseed(os.time())
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
