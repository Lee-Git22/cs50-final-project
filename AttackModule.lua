MonstersModule = require("MonstersModule")

function newEntry(name, TYPE, fn)
    return {
        name = name,
        TYPE = TYPE, -- type of attack(REGULAR, RISKY, HUMAN, MACHINE, ANIMAL)
        parameters = fn
    }
end

-- outputs a single value from attack's base damage + monsters attack stat times multiplier
function Attack(base, multiplier, hitRate)
    return {
        base = base,
        multiplier = multiplier,
        hitRate = hitRate
    }
end


function Buff(ATK, DEF, SPD, hitRate)
    return {
        ATK = ATK,
        DEF = DEF,
        SPD = SPD,
        hitRate = hitRate
    }
end


function getCounter(type1, type2)
    if type1 == "HUMAN" and type2 == "ANIMAL" then
        return 1.5
    elseif type1 == "MACHINE" and type2 == "HUMAN" then
        return 1.5
    elseif type1 == "ANIMAL" and type2 == "MACHINE" then
        return 1.5
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

AttackDataBase = {}
    function AttackDataBase.load()

        laser = table.insert(AttackDataBase,
        newEntry(
            "LASER",
            "MACHINE",
            Attack(15, 1.15, 0.90)
        ))

        bigone = table.insert(AttackDataBase, 
        newEntry(
            "BIG ONE",
            "RISKY",
            Attack(30, 1.5, 0.25)
        ))

        copypasta = table.insert(AttackDataBase, 
        newEntry(
            "COPYPASTA",
            "MACHINE",
            Attack(25, 1.15, 0.7)
        ))

        freethrow = table.insert(AttackDataBase, 
        newEntry(
            "FREE THROW",
            "HUMAN",
            Attack(20, 1.1, 0.9)
        ))

        spacejamdunk = table.insert(AttackDataBase, 
        newEntry(
            "SPACE JAM DUNK",
            "MACHINE",
            Attack(0, 1, 1)
        ))

        goatmode = table.insert(AttackDataBase, 
        newEntry(
            "GOAT MODE",
            "BUFF",
            Buff(50, 30, 30, 1) -- change to 75% 
        ))

        hardd = table.insert(AttackDataBase, 
        newEntry(
            "HARD D",
            "RISKY",
            Attack(20, 1.25, 0.70)
        ))

        slap = table.insert(AttackDataBase, 
        newEntry(
            "SLAP",
            "REGULAR",
            Attack(10, 1.25, 0.95)
        ))

        chugchug = table.insert(AttackDataBase, 
        newEntry(
            "CHUG CHUG",
            "BUFF",
            Buff(20, -15, -15, 1)
        ))

        turkeyshot = table.insert(AttackDataBase, 
        newEntry(
            "TURKEY SLAM",
            "RISKY",
            Attack(25, 1, 0.75)
        ))

        cheapshot = table.insert(AttackDataBase, 
        newEntry(
            "CHEAP SHOT",
            "HUMAN",
            Attack(-15, 1.1, 1)
        ))

        download = table.insert(AttackDataBase, 
        newEntry(
            "DOWNLOAD",
            "RISKY",
            Attack(1, 1.3, 0.70)
        ))

        deeplearn = table.insert(AttackDataBase, 
        newEntry(
            "DEEP LEARN",
            "BUFF", -- change to debuff 
            Buff(15, 10, 10, 0.95)
        ))

        thunderbolt = table.insert(AttackDataBase, 
        newEntry(
            "THUNDER BOLT",
            "REGULAR", -- change to debuff 
            Attack(15, 1.15, 0.65)
        ))

        notrouble = table.insert(AttackDataBase, 
        newEntry(
            "NO TROUBLE",
            "BUFF", 
            Buff(15, 10, 10, 1)
        ))

        piecic = table.insert(AttackDataBase, 
        newEntry(
            "PIECIC",
            "RISKY", -- change to debuff 
            Attack(65, 1, 0.7)
        ))
    end
        -- notes for tomorrow, add debuff and change buff values to be % scaling factors
return AttackDataBase