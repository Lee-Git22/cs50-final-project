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
    function ItemDatabase.loadInventory(Inventory)
        

        item1 = table.insert(Inventory, addItem("POTION", 4))
        item2 = table.insert(Inventory, addItem("ANOTHER ONE", 1))
        item3 = table.insert(Inventory, addItem("MAX POTION", 1))
        item4 = table.insert(Inventory, addItem("TOXIC BERRY", 3))

        return Inventory
    end

    function ItemDatabase.load()
        
        potion = table.insert(ItemDatabase, 
        newItem(
            "POTION",
            "HEAL",
            30
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

        toxicberry = table.insert(ItemDatabase, 
        newItem(
            "TOXIC BERRY",
            "TRADEOFF",
            10
        ))
    end

return ItemDatabase


