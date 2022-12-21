function addItem(name, uses)
    return {
        name = name,
        uses = uses
    }
end

function newItem(name, TYPE, value)
    return {
        name = name,
        TYPE = TYPE,
        value = value
    }
end



ItemDatabase = {}


    function ItemDatabase.load()
        
        partytime = table.insert(ItemDatabase, 
        newItem(
            "PARTY TIME",
            "RECRUIT",
            3
        ))

        anotherone = table.insert(ItemDatabase, 
        newItem(
            "ANOTHER ONE",
            "RECRUIT",
            1
        ))
        
        maxpotion = table.insert(ItemDatabase, 
        newItem(
            "MAX POTION",
            "HEAL",
            10000
        ))

        
        devilfruit = table.insert(ItemDatabase, 
        newItem(
            "DEVIL FRUIT",
            "TRADEOFF",
            20
        ))


        
        sodiepop = table.insert(ItemDatabase, 
        newItem(
            "SODIE POP",
            "HEAL",
            60
        ))

        potion = table.insert(ItemDatabase, 
        newItem(
            "POTION",
            "HEAL",
            20
        ))

        atkberry = table.insert(ItemDatabase, 
        newItem(
            "ATK BERRY",
            "TRADEOFF",
            20
        ))

        defberry = table.insert(ItemDatabase, 
        newItem(
            "DEF BERRY",
            "TRADEOFF",
            20
        ))

        spdberry = table.insert(ItemDatabase, 
        newItem(
            "SPD BERRY",
            "TRADEOFF",
            20
        ))


    end



return ItemDatabase


