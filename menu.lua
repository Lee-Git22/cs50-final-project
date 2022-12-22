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

        if gameState.message == "start" then
            -- Draws action text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("Straw Hat PETER wants to battle!\n\nCLICK TO START", monsterName, input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "attack" then
            -- Draws action text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("%s used %s!", monsterName, input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "cpuAttack" then
            -- Draws action text
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("Enemy %s\nused %s!", monsterName, input),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "item" then
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
                string.format("%s FAINTED", monsterName),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "cpuswitch" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("CPU sends out %s", monsterName),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
        end

        if gameState.message == "playerswitch" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("Player sends out %s", monsterName),
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
            string.format("COMPUTER IS OUT OF FIGHTERS!\nYOU WON THE CULTURE WAR!"),
            font,
            textboxX + borderSize,
            textboxY + borderSize
        )
        end

        if gameState.message == "LOSE" then
            -- Displays action message
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(
                string.format("YOU ARE OUT OF FIGHTERS!\nYOU LOST THE CULTURE WAR..."),
                font,
                textboxX + borderSize,
                textboxY + borderSize
            )
            end

    end


return Menu