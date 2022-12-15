Menu = require("menu")

-- Global menu tables to hold buttons
mainButtons = {}
fightButtons = {}


function love.load()
    gameState = "main" -- Default gamestate

    -- Options for main menu
    table.insert(mainButtons,  Menu.newButton("Fight", function() gameState = "fight" end))
    table.insert(mainButtons, Menu.newButton("Switch", function() print("TBD") end))
    table.insert(mainButtons, Menu.newButton("Item", function() print("Choose an item") end))
    table.insert(mainButtons, Menu.newButton("Run", function() love.event.quit(0) end)) 
    
    -- Options for fight menu
    table.insert(fightButtons, Menu.newButton("Attack 1", 
    function() print("player chose 1"); gameState = "main" end))

    table.insert(fightButtons, Menu.newButton("Attack 2",
     function() print("player chose 2"); gameState = "main" end))

    table.insert(fightButtons, Menu.newButton("Attack 3",
     function() print("player chose 3"); gameState = "main" end))

    table.insert(fightButtons, Menu.newButton("Attack 4",
     function() print("player chose 4"); gameState = "main" end))

end

function love.update(dt)
    -- TODO: Checks which state is loaded and activation their respective buttons
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
            
            -- Checks if button is clicked and calls function if true
            button.now = love.mouse.isDown(1) -- 1 represents left click
            if button.now and not button.last and hot then
                button.fn();
            end

            -- Loads buttons for menu gameState
            Menu.loadButton(buttonColor, button.text, buttonX, buttonY, buttonWidth, BUTTON_HEIGHT)

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

            fightButton.now = love.mouse.isDown(1) 
            if fightButton.now and not fightButton.last and hot and  then
                fightButton.fn();
            end

            Menu.loadButton(buttonColor, fightButton.text, buttonX, buttonY, buttonWidth, BUTTON_HEIGHT)

            cursorY = cursorY + (BUTTON_HEIGHT + margin)
        end
    end

end