function monster(name, stats, moveset)
    return {
        name = name,
        stats = stats,
        moveset = moveset
    }
end

function stats(TYPE, HP, ATK, DEF, SPD)
    return {
        TYPE = TYPE,
        HP = HP,
        ATK = ATK,
        DEF = DEF,
        SPD = SPD
    }
end

function moveset(move1, move2, move3, move4)
    return {
        move1 = move1,
        move2 = move2 or "",
        move3 = move3 or "",
        move4 = move4 or ""
    }
end

MonstersIndex = {}
    function MonstersIndex.load()

        chungus = table.insert(MonstersIndex, 
        monster(
            "BIG CHUNGUS", 
            stats(
                "ANIMAL",
                100,
                15,
                30,
                25), 
            moveset(
                "LASER", 
                "BIG ONE", 
                "COPYPASTA")
        ))

        lebron = table.insert(MonstersIndex, 
        monster(
            "LEBRON JAMES", 
            stats(
                "HUMAN",
                40,
                5,
                2,
                1), 
            moveset(
                "FREE THROW", 
                "SPACE JAM", 
                "GOAT MODE",
                "RETIRE")
        ))

    end
return MonstersIndex

