Menu = require("Menu")
UI = require("UI")
MonstersModule = require("MonstersModule")
ItemsModule = require("ItemsModule")
AttackModule = require("AttackModule")
Battle = require("Battle")

-- Global menu tables to hold buttons
mainButtons = {}
Inventory = {}

MonstersIndex = {}
playerParty = {}
computerParty = {}
AttackDataBase = {}

-- Global values used for respective game state
gameState = {
    phase = "main",
    action = "attack",
    monsterName = "default",
    playerInput = "",
    computerInput = "",
    timer = 0
}

function love.load()  
    MonstersModule.load() -- Loads in monsters into MonstersIndex table
    ItemsModule.load() -- Loads in items into Inventory table
    AttackModule.load() -- Loads in database into Database table

    -- Options for main menu
    table.insert(mainButtons, Menu.newButton("Fight", function() gameState.phase = "fight" end))
    table.insert(mainButtons, Menu.newButton("Switch", function() print("TBD") end))
    table.insert(mainButtons, Menu.newButton("Item", function() gameState.phase = "item" end))
    table.insert(mainButtons, Menu.newButton("Run", function() love.event.quit(0) end)) 
    
    -- fix later with randomized loop 
    for i = 1,5,1
    do
        table.insert(playerParty, MonstersIndex[i]) 
    end
    
    for i = 1,5,1
    do
        table.insert(computerParty, MonstersIndex[i])
    end

    -- Initialize player and computer stats for first monster in party
    playerCombat = {
        DMG = 0,
        ATK = 1,
        DEF = 1,
        SPD = 1
    }

    computerCombat = {
        DMG = 0,
        ATK = 1,
        DEF = 1,
        SPD = 1
    }

end

function love.update(dt)
    gameState.timer = gameState.timer + dt
    
    playerLead = 1 -- placeholder name
    computerLead = 3
    
    --initialize battle parameters
    playerStats = {
        TYPE = playerParty[playerLead].stats.TYPE,
        HP = playerParty[playerLead].stats.HP - playerCombat.DMG,
        ATK = playerParty[playerLead].stats.ATK * playerCombat.ATK,
        DEF = playerParty[playerLead].stats.DEF * playerCombat.DEF,
        SPD = playerParty[playerLead].stats.SPD * playerCombat.SPD,
    }

    computerStats = {
        TYPE = computerParty[computerLead].stats.TYPE,
        HP = computerParty[computerLead].stats.HP - computerCombat.DMG,
        ATK = computerParty[computerLead].stats.ATK * computerCombat.ATK,
        DEF = computerParty[computerLead].stats.DEF * computerCombat.DEF,
        SPD = computerParty[computerLead].stats.SPD * computerCombat.SPD
    }

    if playerStats.SPD >= computerStats.SPD then
        local move1 = "player"
        local move2 = "computer"
    else
        local move1 = "computer"
        local move2 = "player"
    end

    

    if gameState.phase == "battle" then
        
        gameState.computerInput = getCPUmove()
        
        -- For player round
        for i, entry in pairs(AttackDataBase) do -- Look thru database for the attack
            if gameState.playerInput == entry.name then
                if entry.TYPE == "BUFF" then
                    tmptmp = "this"                  
                    tmptmp, playerCombat = calcBuff(tmptmp, entry, playerCombat)
                    print(tmptmp)

                else if entry.TYPE == "DEBUFF" then
                    tmptmp, computerCombat = calcBuff(tmptmp, entry, computerCombat)
                    print(tmptmp)

                    else 
                        -- For attacks
                        tmptmp, entry, playerCombat, playerStats, computerCombat, computerStats = 
                        calcAttack(tmptmp, entry, playerCombat, playerStats, computerCombat, computerStats)
                        print(tmptmp)
                    end
            
                end
            end
        end

               
        -- For computer round
        for j, entry in pairs(AttackDataBase) do
            if gameState.computerInput == entry.name then
                if entry.TYPE == "BUFF" then
                    tmptmp = "this"                  
                    tmptmp, computerCombat = calcBuff(tmptmp, entry, computerCombat)
                    print(string.format("computer move: %s", gameState.computerInput))
                    print(tmptmp)

                else if entry.TYPE == "DEBUFF" then
                    tmptmp, playerCombat = calcBuff(tmptmp, entry, playerCombat)
                    print(string.format("computer move: %s", gameState.computerInput))
                    print(tmptmp)

                    else 
                        -- For attacks
                        print("brew monkey")
                        tmptmp, entry, computerCombat, computerStats, playerCombat, playerStats = 
                        calcAttack(tmptmp, entry, computerCombat, computerStats, playerCombat, playerStats)
                        
                        print(string.format("computer move: %s", gameState.computerInput))
                        print(tmptmp)
                    end
                end
            end
        end
        gameState.phase = "main"
    end
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
        list = {playerParty[playerLead].moveset.move1, playerParty[playerLead].moveset.move2, playerParty[playerLead].moveset.move3, playerParty[playerLead].moveset.move4}

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

                gameState.monsterName = playerParty[playerLead].name
                gameState.action = "attack"
                gameState.playerInput = moves
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
                gameState.playerInput = items.name
                gameState.phase = "dialogue"

                gameState.timer = 0

            end

            Menu.loadButton(buttonColor, string.format("%s x %s", items.name, items.uses), buttonX, buttonY, buttonWidth)

            cursorY = cursorY + (BUTTON_HEIGHT + MARGIN)
        end
    end

    if gameState.phase == "dialogue" then
        cursoyY = 0
        Menu.loadDialogue(gameState.action, gameState.monsterName, gameState.playerInput)
        
        -- Change this to be a keypress later
        if gameState.timer >= 2 then
            gameState.phase = "battle"
        end
        
    end

    if gameState.phase == "battle" then
        --TODO: Draw animations
    end

end