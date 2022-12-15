Menu = require("menu")

-- Global menu tables to hold buttons
mainButtons = {}
fightButtons = {}
itemButtons = {}

-- Global values for dialogue
gameStateVariables = {
    action = "attack",
    monsterName = "CHUNGUS",
    input = "",
    timer = 0
}


function love.load()  
 
    -- Options for main menu
    table.insert(mainButtons, Menu.newButton("Fight", function() print("changing"); gameState = "fight" end))
    table.insert(mainButtons, Menu.newButton("Switch", function() print("TBD") end))
    table.insert(mainButtons, Menu.newButton("Item", function() print("changing"); gameState = "item" end))
    table.insert(mainButtons, Menu.newButton("Run", function() love.event.quit(0) end)) 
    
    -- Options for fight menu
    table.insert(fightButtons, Menu.newButton("SMASH", 
    function() print("player chose 1"); gameState = "dialogue" end))

    table.insert(fightButtons, Menu.newButton("CHARGE UP",
    function() print("player chose 2"); gameState = "dialogue" end))

    table.insert(fightButtons, Menu.newButton("LASER BEAM",
    function() print("player chose 3"); gameState = "dialogue" end))

    table.insert(fightButtons, Menu.newButton("BIG ONE",
    function() print("player chose 4"); gameState = "dialogue" end))

    -- Options for fight menu
    table.insert(itemButtons, Menu.newButton("POTION", 
    function() print("player chose POTION"); gameState = "dialogue" end))

    table.insert(itemButtons, Menu.newButton("FLASH BOMB",
    function() print("player chose FLASH BOMB"); gameState = "dialogue" end))

    table.insert(itemButtons, Menu.newButton("BERRY",
    function() print("player chose BERRY"); gameState = "dialogue" end))

    table.insert(itemButtons, Menu.newButton("GREAT BALL",
    function() print("player chose GREAT BALL"); gameState = "dialogue" end))

end

function love.update(dt)
    -- TODO: Checks which state is loaded and activation their respective buttons
    gameStateVariables.timer = gameStateVariables.timer + dt
    --print(gameStateVariables.timer)
end

function love.draw()
    -- Represents current button y position
    local cursorY = 0

    -- Switch to Main menu
    if gameState == "main" then
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
            if button.now and not button.last and hot and gameStateVariables.timer >= 0.4 then
                gameStateVariables.timer = 0
                button.fn()
            end

            -- Move cursor to prepare for next button
            cursorY = cursorY + (BUTTON_HEIGHT + margin)
        end
    end

    -- Switch to Fight menu 
    if gameState == "fight" then
        cursorY = 0

        -- Load the fight menu
        for i, fightButton in ipairs(fightButtons) do  
            fightButton.last = fightButton.now

            local buttonX = (winWidth) - (buttonWidth) 
            local buttonY = (winHeight) - (total_height) + cursorY 
            local buttonColor = {0.5, 0.5, 0.5, 1.0}

            local mx, my = love.mouse.getPosition()

            local hot = mx > buttonX and mx < buttonX + buttonWidth and my > buttonY and my < buttonY + BUTTON_HEIGHT;
            if hot then
                buttonColor = {0.9, 0.9, 0.9, 1}
            end

            Menu.loadButton(buttonColor, fightButton.text, buttonX, buttonY, buttonWidth, BUTTON_HEIGHT)

            fightButton.now = love.mouse.isDown(1) 
            if fightButton.now and not fightButton.last and hot and gameStateVariables.timer >= 0.4 then
                gameStateVariables.timer = 0
                gameStateVariables.action = "attack"
                gameStateVariables.input = fightButton.text
                fightButton.fn()
            end
        
            cursorY = cursorY + (BUTTON_HEIGHT + margin)
        end
    end

    -- Switch to item menu 
    if gameState == "item" then
        cursorY = 0
        
        -- Load the fight menu
        for i, itemButton in ipairs(itemButtons) do  
            itemButton.last = itemButton.now 

            local buttonX = (winWidth) - (buttonWidth) 
            local buttonY = (winHeight) - (total_height) + cursorY 
            local buttonColor = {0.5, 0.5, 0.5, 1.0}

            local mx, my = love.mouse.getPosition()

            local hot = mx > buttonX and mx < buttonX + buttonWidth and my > buttonY and my < buttonY + BUTTON_HEIGHT;
            if hot then
                buttonColor = {0.9, 0.9, 0.9, 1}
            end

            itemButton.now = love.mouse.isDown(1) 
            if itemButton.now and not itemButton.last and hot and gameStateVariables.timer > 0.4 then
                gameStateVariables.timer = 0
                gameStateVariables.action = "consumable"
                gameStateVariables.input = itemButton.text
                itemButton.fn()
            end

            Menu.loadButton(buttonColor, itemButton.text, buttonX, buttonY, buttonWidth, BUTTON_HEIGHT)

            cursorY = cursorY + (BUTTON_HEIGHT + margin)
        end
    end

    if gameState == "dialogue" then
        cursoyY = 0

        Menu.loadDialogue(gameStateVariables.action, gameStateVariables.monsterName, gameStateVariables.input)

    end
end