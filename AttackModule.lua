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


function Buff(ATK, DEF, SPD)
    return {
        ATK = ATK,
        DEF = DEF,
        SPD = SPD
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

AttackDataBase = {}
    function AttackDataBase.load()

        laser = table.insert(AttackDataBase,
        newEntry(
            "LASER",
            "REGULAR",
            Attack(20, 0.45, 0.90)
        ))

        bigone = table.insert(AttackDataBase, 
        newEntry(
            "BIG ONE",
            "RISKY",
            Attack(40, 1, 0.25)
        ))

        copypasta = table.insert(AttackDataBase, 
        newEntry(
            "COPYPASTA",
            "MACHINE",
            Attack(25, 0.3, 0.7)
        ))

        freethrow = table.insert(AttackDataBase, 
        newEntry(
            "FREE THROW",
            "HUMAN",
            Attack(20, 0.7, 0.9)
        ))

        spacejamdunk = table.insert(AttackDataBase, 
        newEntry(
            "SPACE JAM DUNK",
            "MACHINE",
            Attack(1, 1, 1)
        ))

        goatmode = table.insert(AttackDataBase, 
        newEntry(
            "GOAT MODE",
            "BUFF",
            Buff(40, 40, 40)
        ))

        hardd = table.insert(AttackDataBase, 
        newEntry(
            "HARD D",
            "REGULAR",
            Attack(15, 0.8, 0.80)
        ))
    end
return AttackDataBase