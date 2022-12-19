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
    function Menu.loadDialogue(action, monsterName, input)

        local textboxX = borderSize
        local textboxY = winHeight - BOX_HEIGHT 
        local textboxWidth = BOX_WIDTH - borderSize
        local textboxHeight = BOX_HEIGHT - borderSize

        local actions = {
            attack = "attack",
            consumable = "consumable",
        }
        
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

        if actions[action] == "attack" then
            -- Draws action text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s used %s!", monsterName, input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if actions[action] == "consumable" then
            -- Draws consumable text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("PLAYER used %s!",input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if actions[action] == "battle" then
            --TODO: Draw effects of the battle
        end
    end

return Menu

