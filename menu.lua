winWidth = love.graphics.getWidth();
winHeight = love.graphics.getHeight();
font = love.graphics.newFont(32);

BUTTON_HEIGHT = 48;
buttonWidth = winWidth * (1/4);

margin = 1;

total_height = (BUTTON_HEIGHT + margin) * 4; -- Total height of menu box

Menu = {}

    -- Creates a new button class
    function Menu.newButton(text, fn)
        return {
            text = text,
            fn = fn,
            now = false,
            last = false, -- So each click only registers once
        }
    end

    -- Loads a button 
    function Menu.loadButton(buttonColor, text, buttonX, buttonY, buttonWidth, BUTTON_HEIGHT)
         
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

return Menu