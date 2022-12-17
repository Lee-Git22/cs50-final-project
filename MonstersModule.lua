function monster(name, stats, moveset)
    return {
        name = name,
        stats = stats,
        moveset = moveset
    }
end

function stats(HP, ATK, DEF, SPD)
    return {
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
                100,
                69,
                13,
                25), 
            moveset(
                "LASER", 
                "BIG ONE", 
                "SMASH")
        ))

        lebron = table.insert(MonstersIndex, 
        monster(
            "LEBRON JAMES", 
            stats(
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

