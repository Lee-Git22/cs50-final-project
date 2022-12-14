BUTTON_HEIGHT = 48;

local function newButton(text, fn)
    return {
        text = text,
        fn = fn,
        now = false,
        last = false, -- So each click only registers once
    }
end

local buttons = {};
local fightButtons = {};
local font = nil;

local loadMenu = true;
local loadFight = false;

function love.load()
    font = love.graphics.newFont(32);

    -- Creates a button called start game that passes anon function
    table.insert(buttons, newButton(
        "Fight",
        function()
            -- TODO: Load a fight screen menu
                -- Draws new moveset menu
                -- Disables previous menu
                -- When a moveset is chosen -> perform battle
                -- Back to main menu
            loadFight = true;
        end)
    );

    table.insert(buttons, newButton(
        "Switch",
        function()
          print("TBD")
        end)
    );

    table.insert(buttons, newButton(
        "Item",
        function()
            -- TODO: Load an item screen menu
            print("Choose an item")
        end)
    );

    table.insert(buttons, newButton(
        "Run",
        function()
            love.event.quit(0)
        end)
    );

    table.insert(fightButtons, newButton(
        "Attack 1",
        function()
            print("player chose 1")
        end)
    );

    table.insert(fightButtons, newButton(
        "Attack 2",
        function()
            print("player chose 2")
        end)
    );

    table.insert(fightButtons, newButton(
        "Attack 3",
        function()
            print("player chose 3")
        end)
    );

    table.insert(fightButtons, newButton(
        "Attack 4",
        function()
            print("player chose 4")
        end)
    );
end

function love.update(dt)
    -- TODO: Checks which state is loaded and activation their respective buttons
end

function love.draw()
    local winWidth = love.graphics.getWidth();
    local winHeight = love.graphics.getHeight();

    local buttonWidth = winWidth * (1/4);
    local margin = 1;

    -- Total height of menu box
    local total_height = (BUTTON_HEIGHT + margin) * 4;

    -- Represents current button y position
    local cursorY = 0;

    -- Loads the main menu
    for i, button in ipairs(buttons) do
        button.last = button.now -- Resets button state

        local buttonX = (winWidth) - (buttonWidth) -- Start at right edge of the screen and shift left based on button size
        local buttonY = (winHeight) - (total_height) + cursorY -- Start at bottom of the screen and shift up by menu size and down by cursor amount

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
            if loadMenu then
                button.fn();
            end
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

    -- Switch to Fight menu 
    if loadFight then
        cursorY = 0;
        -- Disables main menu
        loadMenu = false;
           
        -- Load the fight menu
        for i, fightButton in ipairs(fightButtons) do
                
            fightButton.last = fightButton.now -- Resets button state

            local buttonX = (winWidth) - (buttonWidth) -- Start at right edge of the screen and shift left based on button size
            local buttonY = (winHeight) - (total_height) + cursorY -- Start at bottom of the screen and shift up by menu size and down by cursor amount

            local buttonColor = {0.5, 0.5, 0.5, 1.0};

            local mx, my = love.mouse.getPosition(); -- gets position of mouse and separates into mx my coordinate   

            -- Checks if mouse is hovering on a button and brightens if true
            local hot = mx > buttonX and mx < buttonX + buttonWidth and my > buttonY and my < buttonY + BUTTON_HEIGHT;
            if hot then
                buttonColor = {0.9, 0.9, 0.9, 1};
            end

            -- Checks if button is clicked and calls function if true
            fightButton.now = love.mouse.isDown(1) -- 1 represents left click

            if fightButton.now and not fightButton.last and hot then
                if fightMenu then
                        fightButton.fn();
                end
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
                fightButton.text,
                font,
                buttonX,
                buttonY
            )
            -- Move cursor
            cursorY = cursorY + (BUTTON_HEIGHT + margin);
        end
    end
end