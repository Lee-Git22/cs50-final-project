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
                180,
                25,
                30,
                25), 
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
                120,
                10,
                10,
                10), 
            moveset(
                "FREE THROW", 
                "SPACE JAM DUNK", 
                "GOAT MODE",
                "HARD D")
        ))

        brewmonkey = table.insert(MonstersIndex, 
        monster(
            "BREW MONKEY", 
            stats(
                "ANIMAL",
                150,
                35,
                35,
                40), 
            moveset(
                "THUNDER BOLT", 
                "CHUG CHUG", 
                "CHEAP SHOT",
                "TURKEY SLAM")
        ))

        gpt3 = table.insert(MonstersIndex, 
        monster(
            "GPT-3", 
            stats(
                "MACHINE",
                160,
                20,
                10,
                100), 
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
                "ANIMAL",
                115,
                50,
                10,
                50), 
            moveset(
                "TURKEY SLAM", 
                "HARD D", 
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
                225,
                20,
                40,
                25), 
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
                140,
                25,
                70,
                10), 
            moveset(
                "NO TROUBLE", 
                "FREE THROW", 
                "PIECIC",
                "DEEP LEARN")
        ))

        tofurkey = table.insert(MonstersIndex,
        monster(
            "TOFURKEY",
            stats(
                "MACHINE",
                150,
                65,
                15,
                20), 
            moveset(
                "TURKEY SLAM", 
                "LASER", 
                "PIECIC",
                "CURSE")
        ))
        
    end
return MonstersIndex

