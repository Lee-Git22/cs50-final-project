winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()
font = love.graphics.newFont(32)

-- For dialogue box
borderSize = 12
BOX_WIDTH = winWidth - borderSize
BOX_HEIGHT = winHeight * 0.3 

-- For standard buttons
MARGIN = 1
totalMenuHeight = winHeight * 0.3; 
BUTTON_HEIGHT = (totalMenuHeight - borderSize*2)/ 4 + 2

Menu = {}

    -- Used for main/fight/item buttons
    function Menu.newButton(text, fn)
        return {
            text = text,
            fn = fn,
        }
    end
    
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

    -- Loads respective dialogue box based on gamestate inputs
    function Menu.loadDialogue(gameState, fighterName, input)

        local textboxX = borderSize
        local textboxY = winHeight - BOX_HEIGHT 
        local textboxWidth = BOX_WIDTH - borderSize
        local textboxHeight = BOX_HEIGHT - borderSize
        
        fighterName = fighterName
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

        if gameState.message == "START" then
            -- Draws action text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("Straw Hat PETER wants to battle!\n\nCLICK TO START", fighterName, input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "ATTACK" then
            -- Draws action text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s used %s!", fighterName, input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "CPUATTACK" then
            -- Draws action text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("Enemy %s\nused %s!", fighterName, input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "ITEM" then
            -- Draws consumable text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("PLAYER used %s!",input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "HEAL" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s recovered %s HP!", playerParty[playerLead].name, recovered),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "RECRUIT" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            if gameState.playerInput == "ANOTHER ONE" then
                love.graphics.print(
                    string.format("%s JOINED PLAYER PARTY!", addedNames[1]),
                    font,
                    textboxX + borderSize,
                    textboxY + borderSize
                )
            elseif gameState.playerInput == "PARTY TIME" then
                love.graphics.print(
                    string.format("%s and %s \nJOINED PLAYER PARTY!", addedNames[1],addedNames[2]),
                    font,
                    textboxX + borderSize,
                    textboxY + borderSize
                )
            end
        end

        if gameState.message == "TRADEOFF" then
            if gameState.playerInput == "ATK BERRY" then
                            
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.print(
                    string.format("%s\nLOST %s DEF AND GAINED %s ATK", playerParty[playerLead].name, negtrade, postrade ),
                    font,
                    textboxX + borderSize,
                    textboxY + borderSize
                )
            elseif gameState.playerInput == "DEF BERRY" then
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.print(
                    string.format("%s\nLOST %s SPD AND GAINED %s DEF", playerParty[playerLead].name, negtrade, postrade ),
                    font,
                    textboxX + borderSize,
                    textboxY + borderSize
                )
            elseif gameState.playerInput == "SPD BERRY" then
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.print(
                    string.format("%s\nLOST %s ATK AND GAINED %s SPD", playerParty[playerLead].name, negtrade, postrade ),
                    font,
                    textboxX + borderSize,
                    textboxY + borderSize
                )
            elseif gameState.playerInput == "DEVIL FRUIT" then
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.print(
                    string.format("%s\n GAINED %s ATK, %s DEF, %s SPD", playerParty[playerLead].name, postrade, postrade, postrade ),
                    font,
                    textboxX + borderSize,
                    textboxY + borderSize
                )
            end
        end

        if gameState.message == "SUPER EFFECTIVE!" 
        or gameState.message == "not very effective..." then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("it is %s", gameState.message),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end
        
        if gameState.message == "BUFF" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s IS RAMPING UP!", Self.name),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "DEBUFF" then
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s IS SHOOK!", Opponent.name),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end
        
        if gameState.message == "MISS" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s MISSED!", Self.name),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "RISKY" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s missed and hurt itself...", Self.name),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "FAINT" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s FAINTED", fighterName),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "CPUSELECT" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("CPU sends out %s", fighterName),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "PLAYERSELECT" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("Player sends out %s", fighterName),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "NO ITEM" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s HAS NO USES LEFT!", input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "WIN" then
        -- Displays action message
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.print(
            string.format("PETER IS OUT OF FIGHTERS!\nYOU DID IT!!!"),
            font,
            textboxX + borderSize,
            textboxY + borderSize
        )
        end

        if gameState.message == "LOSE" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("YOU ARE OUT OF FIGHTERS!\nAlt+F4......"),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "HELP" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("Select with left click,\nBoth Trainers have 4 Fighters\nRight click to go back"),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end 
    end
return Menu