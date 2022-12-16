Menu = require("menu")
MonstersModule = require("MonstersModule")
ItemsModule = require("ItemsModule")
-- Global menu tables to hold buttons
mainButtons = {}
Inventory = {}

MonstersIndex = {}
playerParty = {}
enemyParty = {}

-- Global values for dialogue
gameState = {
    phase = "main",
    action = "attack",
    monsterName = "default",
    input = "",
    timer = 0
}


function love.load()  
    MonstersModule.load() -- Loads in monsters into MonstersIndex table
    -- print(MonstersIndex[1].stats.DEF) -- for debugging
    -- print(MonstersIndex[1].moveset.move2)
    -- print(MonstersIndex[1]["name"])

    ItemsModule.load() -- Loads in items into Inventory table

    -- Options for main menu
    table.insert(mainButtons, Menu.newButton("Fight", function() print("changing"); gameState.phase = "fight" end))
    table.insert(mainButtons, Menu.newButton("Switch", function() print("TBD") end))
    table.insert(mainButtons, Menu.newButton("Item", function() print("changing"); gameState.phase = "item" end))
    table.insert(mainButtons, Menu.newButton("Run", function() love.event.quit(0) end)) 
    
    -- fix later with loop 
    table.insert(playerParty, MonstersIndex[1]) -- insert first monster from index to playerParty (big chungus)
    table.insert(playerParty, MonstersIndex[2]) 

    print(playerParty[1].name) -- for debugging



    -- -- Options for item menu
    -- table.insert(itemButtons, Menu.newButton("POTION", 
    -- function() print("player chose POTION"); gameState.phase = "dialogue" end))

    -- table.insert(itemButtons, Menu.newButton("FLASH BOMB",
    -- function() print("player chose FLASH BOMB"); gameState.phase = "dialogue" end))

    -- table.insert(itemButtons, Menu.newButton("BERRY",
    -- function() print("player chose BERRY"); gameState.phase = "dialogue" end))

    -- table.insert(itemButtons, Menu.newButton("GREAT BALL",
    -- function() print("player chose GREAT BALL"); gameState.phase = "dialogue" end))

end

function love.update(dt)
    -- TODO: Checks which state is loaded and activation their respective buttons
    gameState.timer = gameState.timer + dt
    --print(gameStateVariables.timer)
end

function love.draw()
    -- Represents current button y position
    local cursorY = 0

    -- Switch to Main menu
    if gameState.phase == "main" then
        cursorY = 0 -- Resets cursor
        
        -- Loads the main menu
        for i, button in ipairs(mainButtons) do
            button.last = button.now -- Resets button state

            local buttonX = (winWidth) - (buttonWidth) -- Start at right edge of the screen and shift left based on button size
            local buttonY = (winHeight) - (total_height) + cursorY -- Start at bottom of the screen and shift up by menu size and down by cursor amount
            local buttonColor = {0.5, 0.5, 0.5, 1.0} -- Sets default button color

            local mx, my = love.mouse.getPosition() -- gets position of mouse and separates into mx my coordinate   
            -- Checks if mouse is hovering on a button and brightens if true
            local hot = mx > buttonX and mx < buttonX + buttonWidth and my > buttonY and my < buttonY + BUTTON_HEIGHT;
            if hot then
                buttonColor = {0.9, 0.9, 0.9, 1}
            end
            
            -- Loads buttons for menu gameState
            Menu.loadButton(buttonColor, button.text, buttonX, buttonY, buttonWidth, BUTTON_HEIGHT)

            -- Checks if button is clicked and calls function if true
            button.now = love.mouse.isDown(1) -- 1 represents left click
            if button.now and not button.last and hot and gameState.timer >= 0.4 then
                gameState.timer = 0
                button.fn()
            end

            -- Move cursor to prepare for next button
            cursorY = cursorY + (BUTTON_HEIGHT + margin)
        end
    end

    -- Switch to Fight menu 
    if gameState.phase == "fight" then
        cursorY = 0

        -- Load the moves for first monster in party      
        list = {playerParty[1].moveset.move1, playerParty[1].moveset.move2, playerParty[1].moveset.move3, playerParty[1].moveset.move4}

        -- For each move in moveset of the current monster
        for i, moves in ipairs(list) do
            local buttonX = (winWidth) - (buttonWidth) 
            local buttonY = (winHeight) - (total_height) + cursorY 
            local buttonColor = {0.5, 0.5, 0.5, 1.0}

            local mx, my = love.mouse.getPosition()
            local hot = mx > buttonX and mx < buttonX + buttonWidth and 
                       my > buttonY and my < buttonY + BUTTON_HEIGHT;
            if hot then
                buttonColor = {0.9, 0.9, 0.9, 1}
            end

            Menu.loadButton(buttonColor, moves, buttonX, buttonY, buttonWidth, BUTTON_HEIGHT)

            click = love.mouse.isDown(1) 
            if click and hot and gameState.timer >= 0.2 then
                gameState.timer = 0

                gameState.monsterName = playerParty[1].name
                gameState.action = "attack"
                gameState.input = moves
                gameState.phase = "dialogue"

                gameState.timer = 0

            end
            
            cursorY = cursorY + (BUTTON_HEIGHT + margin)
        end

    end

    -- Switch to item menu 
    if gameState.phase == "item" then
        cursorY = 0
        
        -- Load the fight menu
        for i, items in ipairs(Inventory) do  
            
            local buttonX = (winWidth) - (buttonWidth) 
            local buttonY = (winHeight) - (total_height) + cursorY 
            local buttonColor = {0.5, 0.5, 0.5, 1.0}

            local mx, my = love.mouse.getPosition()
            local hot = mx > buttonX and mx < buttonX + buttonWidth and 
                       my > buttonY and my < buttonY + BUTTON_HEIGHT;
            if hot then
                buttonColor = {0.9, 0.9, 0.9, 1}
            end

            click = love.mouse.isDown(1) 
            if click and hot and gameState.timer > 0.2 then
                gameState.timer = 0

                gameState.action = "consumable"
                gameState.input = items.name
                gameState.phase = "dialogue"

                gameState.timer = 0

            end

            Menu.loadButton(buttonColor, items.name, buttonX, buttonY, buttonWidth, BUTTON_HEIGHT)

            cursorY = cursorY + (BUTTON_HEIGHT + margin)
        end
    end

    if gameState.phase == "dialogue" then
        cursoyY = 0
        Menu.loadDialogue(gameState.action, gameState.monsterName, gameState.input)
        print(gameState.timer)
        
        -- Change this to be a keypress 
        if gameState.timer >= 2 then
            gameState.phase = "main"
        end
    end
end