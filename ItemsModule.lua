function newItem(name, uses)
    return {
        name = name,
        uses = uses
    }
end

Inventory = {}
    function Inventory.load()

        potion = table.insert(Inventory, newItem("POTION", 2))
        flashBomb = table.insert(Inventory, newItem("FLASH BOMB", 1))
        appleJuice = table.insert(Inventory, newItem("APPLE JUICE", 3))
        greatBall = table.insert(Inventory, newItem("GREAT BALL", 1))
        
    end
return Inventory