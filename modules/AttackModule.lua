FightersModule = require("modules/FightersModule")

-- For adding new attacks into AttackDatabase
function newEntry(name, TYPE, fn)
    return {
        name = name,
        TYPE = TYPE, -- type of attack(RISKY, HUMAN, MACHINE, ANIMAL)
        parameters = fn
    }
end

-- Functions used to set parameters for battle calculations
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

-- Consists of all attacks and their parameters
AttackDataBase = {}
    -- Loads the datatable on game start
    function AttackDataBase.load()

        -- RISKY MOVES --
        bigone = table.insert(AttackDataBase, 
        newEntry(
            "BIG ONE",
            "RISKY",
            Attack(50, 2, 0.33)
        ))

        hardd = table.insert(AttackDataBase, 
        newEntry(
            "HARD D",
            "RISKY",
            Attack(40, 1.15, 0.65)
        ))

        turkeyslam = table.insert(AttackDataBase, 
        newEntry(
            "TURKEY SLAM",
            "RISKY",
            Attack(25, 1.5, 0.85)
        ))


        -- MAGIC MOVES --
        piecic = table.insert(AttackDataBase, 
        newEntry(
            "PIECIC",
            "MAGIC",  
            Attack(25, 1, 0.85)
        ))
        
        thunderbolt = table.insert(AttackDataBase, 
        newEntry(
            "THUNDER BOLT",
            "MAGIC", 
            Attack(30, 1.15, 0.9)
        ))
 
        spacejamdunk = table.insert(AttackDataBase, 
        newEntry(
            "SPACE JAM",
            "MAGIC",
            Attack(0, 2, 1)
        ))

        -- ANIMAL MOVES --
        bite = table.insert(AttackDataBase,
        newEntry(
            "BITE",
            "ANIMAL",
            Attack(20, 1.25, 1)
        ))

        cheapshot = table.insert(AttackDataBase, 
        newEntry(
            "CHEAP SHOT",
            "ANIMAL",
            Attack(-20, 1.75, 1)
        ))

        -- MACHINE MOVES --
        laser = table.insert(AttackDataBase,
        newEntry(
            "LASER",
            "MACHINE",
            Attack(0, 2, 1)
        ))

        paywall = table.insert(AttackDataBase, 
        newEntry(
            "PAYWALL",
            "MACHINE",
            Attack(35, 0.85, 0.9)
        ))

        -- HUMAN MOVES --
        freethrow = table.insert(AttackDataBase, 
        newEntry(
            "FREE THROW",
            "HUMAN",
            Attack(10, 1.8, 0.9)
        ))
        
        slap = table.insert(AttackDataBase, 
        newEntry(
            "SLAP",
            "HUMAN",
            Attack(40, 1.15, 1)
        ))

        surf = table.insert(AttackDataBase, 
        newEntry(
            "SURF",
            "HUMAN",
            Attack(40, 1, 0.925)
        ))

        --BUFF/DEBUFFS --
        beef = table.insert(AttackDataBase, 
        newEntry(
            "BEEF",
            "BUFF", 
            Buff(1.25, 1.25, 0.5, 0.75)
        ))

        curse = table.insert(AttackDataBase,
        newEntry(
            "CURSE",
            "DEBUFF",  
            Buff(1.5, 0.25, 0.25, 0.9)
        ))

        deeplearn = table.insert(AttackDataBase, 
        newEntry(
            "DEEP LEARN",
            "BUFF", 
            Buff(1.38, 1, 0.8, 0.85)
        ))

        dbldbl = table.insert(AttackDataBase, 
        newEntry(
            "DBL DBL",
            "BUFF",
            Buff(2, 0.25, 2, 0.85)
        ))

        goatmode = table.insert(AttackDataBase, 
        newEntry(
            "GOAT MODE",
            "BUFF",
            Buff(2, 1, 2, 0.8) 
        ))

        spartanrage = table.insert(AttackDataBase, 
        newEntry(
            "SPARTAN RAGE",
            "BUFF",
            Buff(2, 0.25, 1, 0.9) 
        ))

        download = table.insert(AttackDataBase, 
        newEntry(
            "DOWNLOAD",
            "DEBUFF",
            Buff(1, 0.75, 0.75, 1)
        ))

    end
return AttackDataBase