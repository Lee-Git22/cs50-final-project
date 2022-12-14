BUTTON_HEIGHT = 64;

local function newButton(text, fn)
    return {
        text = text,
        fn = fn,

        now = false,
        last = false, -- So each click only registers once
    }
end

local buttons = {};
local font = nil;

function love.load()
    font = love.graphics.newFont(32);

    -- Creates a button called start game that passes anon function
    table.insert(buttons, newButton(
        "Fight",
        function()
            print("Choose a move")
        end)
    );

    table.insert(buttons, newButton(
        "Item",
        function()
            print("Choose an item")
        end)
    );

    table.insert(buttons, newButton(
        "Run",
        function()
            love.event.quit(0)
        end)
    );

end

function love.update(dt)

end

function love.draw()
    local winWidth = love.graphics.getWidth();
    local winHeight = love.graphics.getHeight();

    local buttonWidth = winWidth * (1/4);
    local margin = 16;

    -- Total height of menu box
    local total_height = (BUTTON_HEIGHT + margin) * #buttons;
    -- Represents current button y position
    local cursorY = 0;

    -- Loops thru every button in buttons table 
    for i, button in ipairs(buttons) do
        button.last = now -- Resets the button each loop 

        local buttonX = (winWidth * 0.5) - (buttonWidth * 0.5) -- Start at middle of the screen and center left based on button size
        local buttonY = (winHeight * 0.5) - (total_height * 0.5) + cursorY -- Start at middle of the screen and shift up by menu size and down by cursor amount

        local buttonColor = {0.5, 0.5, 0.5, 1.0};

        local mx, my = love.mouse.getPosition(); -- gets position of mouse and separates into mx my coordinate   

        -- Checks if mouse is hovering on a button and brightens if true
        local hot = mx > buttonX and mx < buttonX + buttonWidth and my > buttonY and my < buttonY + BUTTON_HEIGHT;
        if hot then
            buttonColor = {0.9, 0.9, 0.9, 1};
        end
        
        -- Checks if button is clicked and calls function if true
        button.now = love.mouse.isDown(1) -- 1 represents left click
        if button.now and not button.last and hot then
            button.fn();
        end
        
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
            button.text,
            font,
            buttonX,
            buttonY

        )

        -- Move cursor
        cursorY = cursorY + (BUTTON_HEIGHT + margin);
    end
end