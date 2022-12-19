Menu = require("Menu")
UI = require("UI")
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
    ItemsModule.load() -- Loads in items into Inventory table

    -- Options for main menu
    table.insert(mainButtons, Menu.newButton("Fight", function() gameState.phase = "fight" end))
    table.insert(mainButtons, Menu.newButton("Switch", function() print("TBD") end))
    table.insert(mainButtons, Menu.newButton("Item", function() gameState.phase = "item" end))
    table.insert(mainButtons, Menu.newButton("Run", function() love.event.quit(0) end)) 
    
    -- fix later with loop 
    table.insert(playerParty, MonstersIndex[2]) -- insert first monster from index to playerParty (big chungus)
    table.insert(playerParty, MonstersIndex[1]) 
    
    table.insert(enemyParty, MonstersIndex[1])
    table.insert(enemyParty, MonstersIndex[2])

end

function love.update(dt)
    -- TODO: Checks which state is loaded and activation their respective buttons
    gameState.timer = gameState.timer + dt


end

function love.draw()
    -- Represents current button y position
    local cursorY = 0

    UI.drawBackground()
    UI.drawPlayer()
    UI.drawEnemy()

    -- Switch to Main menu
    if gameState.phase == "main" then
        cursorY = 0 -- Resets cursor
        
        -- Loads the main menu
        for i, button in ipairs(mainButtons) do            
            local buttonX = winWidth * 0.75 -- start 1/4 way in from right corner
            local buttonWidth =  winWidth * 0.25 - borderSize 
            local buttonY = (winHeight) - (totalMenuHeight) + cursorY -- Start at bottom of the screen and shift up by menu size and down by cursor amount
            local buttonColor = {0.9, 0.9, 0.9, 1.0} -- Sets default button color

            local mx, my = love.mouse.getPosition() -- gets position of mouse and separates into mx my coordinate   
            -- Checks if mouse is hovering on a button and brightens if true
            local hot = mx > buttonX and mx < buttonX + buttonWidth and my > buttonY and my < buttonY + BUTTON_HEIGHT
            if hot then
                buttonColor = {0.4, 0.4, 0.4, 1}
            end

            -- Loads buttons for menu gameState
            Menu.loadButton(buttonColor, button.text, buttonX, buttonY, buttonWidth)

            -- Checks if button is clicked and calls function if true
            local leftClick = love.mouse.isDown(1) -- 1 represents left click
            if leftClick and hot and gameState.timer >= 0.3 then
                gameState.timer = 0
                button.fn()
            end

            -- Move cursor to prepare for next button
            cursorY = cursorY + (BUTTON_HEIGHT + MARGIN)
        end

        
    end

    -- Switch to Fight menu 
    if gameState.phase == "fight" then
        cursorY = 0

        -- Load the moves for first monster in party      
        list = {playerParty[1].moveset.move1, playerParty[1].moveset.move2, playerParty[1].moveset.move3, playerParty[1].moveset.move4}

        -- For each move in moveset of the current monster
        for i, moves in ipairs(list) do
            local buttonX = (winWidth) * 0.6
            local buttonWidth = (winWidth) * 0.4 - borderSize
            local buttonY = (winHeight) - (totalMenuHeight) + cursorY
            local buttonColor = {0.9, 0.9, 0.9, 1.0}

            local mx, my = love.mouse.getPosition()
            local hot = mx > buttonX and mx < winWidth and 
                       my > buttonY and my < buttonY + BUTTON_HEIGHT;
            if hot then
                buttonColor = {0.4, 0.4, 0.4, 1}
            end

            Menu.loadButton(buttonColor, moves, buttonX, buttonY, buttonWidth)

            local leftClick = love.mouse.isDown(1) 
            if leftClick and hot and gameState.timer >= 0.3 then
                gameState.timer = 0

                gameState.monsterName = playerParty[1].name
                gameState.action = "attack"
                gameState.input = moves
                gameState.phase = "dialogue"

                gameState.timer = 0

            end
            
            cursorY = cursorY + (BUTTON_HEIGHT + MARGIN)
        end
    end

    -- Switch to item menu 
    if gameState.phase == "item" then
        cursorY = 0
        
        -- Load the fight menu
        for i, items in ipairs(Inventory) do  
            
            local buttonX = (winWidth * 0.6) 
            local buttonWidth = (winWidth) * 0.4 - borderSize
            local buttonY = (winHeight) - (totalMenuHeight) + cursorY
            local buttonColor = {0.9, 0.9, 0.9, 1.0}

            local mx, my = love.mouse.getPosition()
            local hot = mx > buttonX and mx < winWidth and 
                       my > buttonY and my < buttonY + BUTTON_HEIGHT;
            if hot then
                buttonColor = {0.4, 0.4, 0.4, 1}
            end

            local leftClick = love.mouse.isDown(1) 
            if leftClick and hot and gameState.timer > 0.3 then
                gameState.timer = 0

                gameState.action = "consumable"
                gameState.input = items.name
                gameState.phase = "dialogue"

                gameState.timer = 0

            end

            Menu.loadButton(buttonColor, items.name, buttonX, buttonY, buttonWidth)

            cursorY = cursorY + (BUTTON_HEIGHT + MARGIN)
        end
    end

    if gameState.phase == "dialogue" then
        cursoyY = 0
        Menu.loadDialogue(gameState.action, gameState.monsterName, gameState.input)
        
        -- Change this to be a keypress later
        if gameState.timer >= 2 then
            gameState.phase = "main"
        end
        
    end

    if gameState.phase == "battle" then
        --TODO: Draw animations
    end

end