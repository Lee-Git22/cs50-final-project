-- For creating Fighters
function fighter(name, stats, moveset, sprite1, sprite2, cry)
    return {
        name = name,
        stats = stats,
        moveset = moveset,
        sprite1 = sprite1,
        sprite2 = sprite2,
        cry = cry
    }
end
-- Sets the stats for each fighter
function stats(TYPE, HP, ATK, DEF, SPD)
    return {
        TYPE = TYPE,
        HP = HP,
        ATK = ATK,
        DEF = DEF,
        SPD = SPD
    }
end
-- Sets the moveset for each fighter
function moveset(move1, move2, move3, move4)
    return {
        move1 = move1,
        move2 = move2 or "",
        move3 = move3 or "",
        move4 = move4 or ""
    }
end

-- Holds fighter information for all fighters
FightersIndex = {}
    function FightersIndex.load()

        brewmonkey = table.insert(FightersIndex, 
        fighter(
            "BREW MONKEY", 
            stats(
                "ANIMAL",
                140,
                70,
                15,
                60), 
            moveset(
                "SURF", 
                "DBL DBL", 
                "CHEAP SHOT",
                "TURKEY SLAM"),
                love.graphics.newImage("sprites/brewmonkeyback.png"),
                love.graphics.newImage("sprites/brewmonkeyfront.png"),
                love.audio.newSource("audio/monstercry/brewmonkeycry.wav", "static")
        ))

        chungus = table.insert(FightersIndex, 
        fighter(
            "BIG CHUNGUS", 
            stats(
                "ANIMAL",
                200,
                35,
                40,
                35), 
            moveset(
                "BITE", 
                "BIG ONE", 
                "CURSE",
                "SLAP"),
                love.graphics.newImage("sprites/chungusback.png"),
                love.graphics.newImage("sprites/chungusfront.png"),
                love.audio.newSource("audio/monstercry/chunguscry.wav", "static")
        ))

        lebron = table.insert(FightersIndex, 
        fighter(
            "LEBRON JAMES", 
            stats(
                "HUMAN",
                90,
                45,
                30,
                5), 
            moveset(
                "FREE THROW", 
                "SPACE JAM", 
                "GOAT MODE",
                "HARD D"),
                love.graphics.newImage("sprites/lebronback.png"),
                love.graphics.newImage("sprites/lebronfront.png"),
                love.audio.newSource("audio/monstercry/lebroncry.wav", "static")
        ))

        gpt3 = table.insert(FightersIndex, 
        fighter(
            "GPT-3", 
            stats(
                "MACHINE",
                190,
                45,
                45,
                45), 
            moveset(
                "DOWNLOAD", 
                "DEEP LEARN", 
                "LASER",
                "PIECIC"),
                love.graphics.newImage("sprites/gpt3back.png"),
                love.graphics.newImage("sprites/gpt3front.png"),
                love.audio.newSource("audio/monstercry/gpt3cry.wav", "static")
        ))

        pikachu = table.insert(FightersIndex,
        fighter(
            "PIKACHU",
            stats(
                "MAGIC",
                135,
                80,
                10,
                50), 
            moveset(
                "TURKEY SLAM", 
                "SURF", 
                "SLAP",
                "THUNDER BOLT"),
                love.graphics.newImage("sprites/pikachuback.png"),
                love.graphics.newImage("sprites/pikachufront.png"),
                love.audio.newSource("audio/monstercry/pikachucry.wav", "static")
        ))

        jackiechan = table.insert(FightersIndex,
        fighter(
            "JACKIE CHAN",
            stats(
                "HUMAN",
                170,
                65,
                35,
                40), 
            moveset(
                "CHEAP SHOT", 
                "HARD D", 
                "BEEF",
                "SPARTAN RAGE"),
                love.graphics.newImage("sprites/jackieback.png"),
                love.graphics.newImage("sprites/jackiefront.png"),
                love.audio.newSource("audio/monstercry/jackiecry.wav", "static")
        ))

        ironman = table.insert(FightersIndex,
        fighter(
            "IRON MAN",
            stats(
                "MACHINE",
                210,
                65,
                30,
                10), 
            moveset(
                "DBL DBL", 
                "DOWNLOAD", 
                "LASER",
                "BIG ONE"),
                love.graphics.newImage("sprites/ironmanback.png"),
                love.graphics.newImage("sprites/ironmanfront.png"),
                love.audio.newSource("audio/monstercry/ironmancry.wav", "static")
        ))

        pieduck = table.insert(FightersIndex,
        fighter(
            "PIE DUCK",
            stats(
                "ANIMAL",
                175,
                58,
                35,
                20), 
            moveset(
                "BEEF", 
                "FREE THROW", 
                "PIECIC",
                "DEEP LEARN"),
                love.graphics.newImage("sprites/pieduckback.png"),
                love.graphics.newImage("sprites/pieduckfront.png"),
                love.audio.newSource("audio/monstercry/pieduckcry.wav", "static")
        ))

        kratos = table.insert(FightersIndex,
        fighter(
            "KRATOS",
            stats(
                "MAGIC",
                300,
                45,
                0,
                10), 
            moveset(
                "FREE THROW", 
                "CURSE", 
                "SPARTAN RAGE",
                "SLAP"),
                love.graphics.newImage("sprites/kratosback.png"),
                love.graphics.newImage("sprites/kratosfront.png"),
                love.audio.newSource("audio/monstercry/kratoscry.wav", "static")
        ))
        
    end
return FightersIndex

