winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()
font = love.graphics.newFont(32)


borderSize = 12
-- For dialogue box
BOX_WIDTH = winWidth - borderSize
BOX_HEIGHT = winHeight * 0.3 

-- For standard buttons
MARGIN = 1
-- total_height
totalMenuHeight = winHeight * 0.3; 
BUTTON_HEIGHT = (totalMenuHeight - borderSize*2)/ 4 + 2
Menu = {}

    -- Creates a new button class
    function Menu.newButton(text, fn)
        return {
            text = text,
            fn = fn,
        }
    end
    
    -- Loads a button 
    function Menu.loadButton(buttonColor, text, buttonX, buttonY, buttonWidth)
         
            -- Draws a button
            love.graphics.setColor(unpack(buttonColor));
            love.graphics.rectangle(
                "fill",
                buttonX,
                buttonY,
                buttonWidth, 
                BUTTON_HEIGHT
            )

            -- Writes text for button
            love.graphics.setColor(0, 0, 0);
            love.graphics.print(
            text,
            font,
            buttonX,
            buttonY
        )
    end

    -- Loads a dialogue box
    function Menu.loadDialogue(gameState, monsterName, input)

        local textboxX = borderSize
        local textboxY = winHeight - BOX_HEIGHT 
        local textboxWidth = BOX_WIDTH - borderSize
        local textboxHeight = BOX_HEIGHT - borderSize

        -- local actions = {
        --     attack = "attack",
        --     consumable = "consumable",
        -- }
        
        monsterName = monsterName
        input = input

        -- Draws textbox border
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle(
            "fill",
            textboxX,
            textboxY,
            textboxWidth,
            textboxHeight
        )

        if gameState.action == "attack" then
            -- Draws action text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s used %s!", monsterName, input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.action == "consumable" then
            -- Draws consumable text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("PLAYER used %s!",input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.action == "SUPER EFFECTIVE!" 
        or gameState.action == "NOT VERY EFFECTIVE..." then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("IT IS %s", gameState.action),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end
        
        if gameState.action == "BUFF" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s IS RAMPING UP", buffTarget),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.action == "DEBUFF" then
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s IS SHOOK", curseTarget),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end
        
        if gameState.action == "MISS" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("IT MISSED"),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.action == "RISKY" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("IT MISSED AND HURT ITSELF"),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

    end

return Menu