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

        brewmonkey = table.insert(MonstersIndex, 
        monster(
            "BREW MONKEY", 
            stats(
                "ANIMAL",
                120,
                70,
                35,
                60), 
            moveset(
                "SURF", 
                "CHUG CHUG", 
                "CHEAP SHOT",
                "TURKEY SLAM")
        ))

        chungus = table.insert(MonstersIndex, 
        monster(
            "BIG CHUNGUS", 
            stats(
                "ANIMAL",
                200,
                35,
                50,
                35), 
            moveset(
                "BITE", 
                "BIG ONE", 
                "CURSE",
                "SLAP")
        ))

        lebron = table.insert(MonstersIndex, 
        monster(
            "LEBRON JAMES", 
            stats(
                "HUMAN",
                140,
                35,
                20,
                5), 
            moveset(
                "FREE THROW", 
                "SPACE JAM DUNK", 
                "GOAT MODE",
                "HARD D")
        ))

        gpt3 = table.insert(MonstersIndex, 
        monster(
            "GPT-3", 
            stats(
                "MACHINE",
                190,
                30,
                30,
                45), 
            moveset(
                "DOWNLOAD", 
                "DEEP LEARN", 
                "LASER",
                "COPYPASTA")
        ))

        pikachu = table.insert(MonstersIndex,
        monster(
            "PIKACHU",
            stats(
                "MAGIC",
                115,
                100,
                10,
                50), 
            moveset(
                "TURKEY SLAM", 
                "SURF", 
                "SLAP",
                "THUNDER BOLT")
        ))

        jackiechan = table.insert(MonstersIndex,
        monster(
            "JACKIE CHAN",
            stats(
                "HUMAN",
                170,
                55,
                25,
                40), 
            moveset(
                "CHEAP SHOT", 
                "HARD D", 
                "NO TROUBLE",
                "SPACE JAM DUNK")
        ))

        ironman = table.insert(MonstersIndex,
        monster(
            "IRON MAN",
            stats(
                "MACHINE",
                210,
                55,
                30,
                10), 
            moveset(
                "CHUG CHUG", 
                "DOWNLOAD", 
                "LASER",
                "BIG ONE")
        ))

        pieduck = table.insert(MonstersIndex,
        monster(
            "PIE DUCK",
            stats(
                "ANIMAL",
                175,
                48,
                35,
                20), 
            moveset(
                "NO TROUBLE", 
                "FREE THROW", 
                "PIECIC",
                "DEEP LEARN")
        ))

        kratos = table.insert(MonstersIndex,
        monster(
            "KRATOS",
            stats(
                "MAGIC",
                240,
                45,
                0,
                30), 
            moveset(
                "FREE THROW", 
                "CURSE", 
                "SPARTAN RAGE",
                "SLAP")
        ))
        
    end
return MonstersIndex

