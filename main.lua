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
cpuParty = {}
AttackDataBase = {}

-- Global values used for respective game state
gameState = {
    phase = "main",
    turn = "",
    message = "",
    playerInput = "", -- the move player chooses for the round
    computerInput = "", -- computers move for the round 
    timer = 0
}

function love.load()  
    math.randomseed(os.time()) -- Randoms the seed everytime on launch
    MonstersModule.load() -- Loads in monsters into MonstersIndex table
    ItemsModule.load() -- Loads in items into Inventory table
    AttackModule.load() -- Loads in database into Database table

    -- Options for main menu
    table.insert(mainButtons, Menu.newButton("Fight", function() gameState.phase = "fight" end))
    table.insert(mainButtons, Menu.newButton("Switch", function() cpuCombat = resetCombat(cpuCombat); cpuLead = cpuLead + 1 end)) -- Add this feature later
    table.insert(mainButtons, Menu.newButton("Item", function() gameState.phase = "item" end))
    table.insert(mainButtons, Menu.newButton("Run", function() love.event.quit(0) end)) 
    
    -- Loads in 3 monsters for player and 4 for cpu
    for i = 1,3,1
    do
        local tmp = math.random(1,9)
        table.insert(playerParty, MonstersIndex[i]) 
    end
    
    for i = 1,4,1
    do
        local tmp = math.random(1,9)
        table.insert(cpuParty, MonstersIndex[i])
    end

    -- Sets first monster in party as party leader (default parameter)
    playerLead = 1 
    cpuLead = 1

    playerUI = true
    cpuUI = true
end

function love.update(dt)
    gameState.timer = gameState.timer + dt -- Used for menu display and to stop accidental double clicks

    -- Stats used for battle calculations for the current monsters in battle
    playerStats = {
        TYPE = playerParty[playerLead].stats.TYPE,
        HP = playerParty[playerLead].stats.HP - playerCombat.DMG,
        ATK = playerParty[playerLead].stats.ATK * playerCombat.ATK,
        DEF = playerParty[playerLead].stats.DEF * playerCombat.DEF,
        SPD = playerParty[playerLead].stats.SPD * playerCombat.SPD,
    }

    cpuStats = {
        TYPE = cpuParty[cpuLead].stats.TYPE,
        HP = cpuParty[cpuLead].stats.HP - cpuCombat.DMG,
        ATK = cpuParty[cpuLead].stats.ATK * cpuCombat.ATK,
        DEF = cpuParty[cpuLead].stats.DEF * cpuCombat.DEF,
        SPD = cpuParty[cpuLead].stats.SPD * cpuCombat.SPD
    }

    -- Load the moves for first monster in party      
    playerList = {
        playerParty[playerLead].moveset.move1, 
        playerParty[playerLead].moveset.move2, 
        playerParty[playerLead].moveset.move3, 
        playerParty[playerLead].moveset.move4
    }
    
    -- For player round
    if gameState.phase == "playerRound" and gameState.turn == "player" then

        -- Change targets for battle message display
        Self = playerParty[playerLead]
        Opponent = cpuParty[cpuLead]

        for i, entry in pairs(AttackDataBase) do -- Look thru database for the attack selected
            if gameState.playerInput == entry.name then
                
                if entry.TYPE == "BUFF" then
                    gameState, playerCombat = calcBuff(gameState, entry, playerCombat)
                
                elseif entry.TYPE == "DEBUFF" then
                    gameState, cpuCombat = calcBuff(gameState, entry, cpuCombat)
                else -- For attacks
                    gameState, entry, playerCombat, playerStats, cpuCombat, cpuStats = 
                    calcAttack(gameState, entry, playerCombat, playerStats, cpuCombat, cpuStats)
                end
                
                if gameState.message == "FAINT" then
                    gameState.timer = 0
                    gameState.phase = "FAINT"
                else
                    gameState.timer = 0
                    gameState.phase = "playerAction"
                end
                -- Reset timer for next message
                
            end
        end
    end

    if gameState.phase == "cpuRound" and gameState.turn == "cpu" then

        Self = cpuParty[cpuLead]
        Opponent = playerParty[playerLead]

        for i, entry in pairs(AttackDataBase) do
            if gameState.computerInput == entry.name then
                
                if entry.TYPE == "BUFF" then
                    gameState, cpuCombat = calcBuff(gameState, entry, cpuCombat)

                elseif entry.TYPE == "DEBUFF" then                   
                    gameState, playerCombat = calcBuff(gameState, entry, playerCombat)
                    -- gameState.message = "DEBUFF"
                else 
                    -- For attacks
                    gameState, entry, cpuCombat, cpuStats, playerCombat, playerStats = 
                    calcAttack(gameState, entry, cpuCombat, cpuStats, playerCombat, playerStats)
                end

                if gameState.message == "FAINT" then
                    gameState.timer = 0
                    gameState.phase = "FAINT"
                    
                else
                    gameState.timer = 0
                    gameState.phase = "cpuAction"
                    gameState.turn = "player"  
                end


            end
        end       
    end
    -- end
    print(turn)
    print(gameState.turn)
end

function love.draw()

    -- Represents current button y position
    local cursorY = 0

    UI.drawBackground()
    if playerUI then 
        UI.drawPlayer()
    end
    if cpuUI then
        UI.drawEnemy()
    end
    
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

        -- For each move in moveset of the current monster
        for i, moves in ipairs(playerList) do
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
    
                gameState.message = "attack"
                gameState.playerInput = moves

                turn = 1
                -- Determines who turn 1 goes to 
                if playerStats.SPD >= cpuStats.SPD then
                    gameState.turn = "player"
                    gameState.phase = "dialogue"
                 else
                    gameState.turn = "cpu"
                    gameState.computerInput = getCPUmove() -- Get computers move
                    gameState.phase = "cpuDialogue"
                 end

                
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

                gameState.message = "consumable"
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
        Menu.loadDialogue(gameState, playerParty[playerLead].name, gameState.playerInput)
        
        -- Change this to be a keypress later
        if gameState.timer >= 1.5 then
            gameState.phase = "playerRound"
            gameState.timer = 0
        end
    end

    if gameState.phase == "playerAction" then
        Menu.loadDialogue(gameState, playerParty[playerLead].name, gameState.playerInput)

        if gameState.timer >= 1.5 then
            
            -- if turn 1 just finished then go to turn 2, otherwise reset
            if turn == 1 then
                gameState.phase = "cpuDialogue"
                gameState.turn = "cpu"
                turn = 2 
            else 
                gameState.phase = "main"
            end
            gameState.timer = 0
        end
    end

    if gameState.phase == "cpuDialogue" then
        -- Displays CPU monster used X 
        gameState.message = "cpuAttack"
        Menu.loadDialogue(gameState, cpuParty[cpuLead].name, gameState.computerInput)
        
        -- Change this to be a keypress later
        if gameState.timer >= 1.5 then
            gameState.phase = "cpuRound" -- in love.update
            gameState.timer = 0
        end
        
    end

    if gameState.phase == "cpuAction" then
        Menu.loadDialogue(gameState, cpuParty[cpuLead].name, gameState.computerInput)

        if gameState.timer >= 1.5 then

            if turn == 1 then 
                turn = 2
                gameState.phase = "dialogue"
                gameState.message = "attack"
                gameState.turn = "player"
                gameState.timer = 0
            else
                gameState.phase = "main"
                gameState.timer = 0
            end
        end
    end

    if gameState.phase == "FAINT" then       
        Menu.loadDialogue(gameState, Opponent.name) -- Displays X monster FAINTED 
        
        if gameState.timer >= 1.5 then
            
            -- Determine which side fainted
            if cpuStats.HP == 0 then
                cpuUI = false
                gameState.phase = "cpuSelect" -- cpu switch
                gameState.timer = 0 
            else 
                playerUI = false
                gameState.phase = "playerSelect" -- player switch
                gameState.timer = 0
            end

            
            
        end
    end

    if gameState.phase == "cpuSelect" then
        -- keeps X is FAINTED on the screen
        --Menu.loadDialogue(gameState, Opponent)
        
        if gameState.timer >= 1 then
            
            cpuCombat = resetCombat(cpuCombat) -- resets combat stats for next monster
            cpuLead = cpuLead + 1 -- shift party up by 1

            cpuUI = true 
            
            gameState.message = "cpuswitch"
            gameState.phase = "cpuswitch"
            gameState.timer = 0
        end

    end

    if gameState.phase == "cpuswitch" then
        --displays CPU sends out X 
        Menu.loadDialogue(gameState, cpuParty[cpuLead].name)
        if gameState.timer >= 1.5 then
            gameState.phase = "main"
            gameState.timer = 0
        end
    end
    
    if gameState.phase == "playerSelect" then
        if gameState.timer >= 0.5 then
            playerCombat = resetCombat(playerCombat)
            playerLead = playerLead + 1

            playerUI = true

            gameState.message = "playerswitch"
            gameState.phase = "playerswitch"
            gameState.timer = 0
        end
    end

    if gameState.phase == "playerswitch" then
        --displays CPU sends out X 
        Menu.loadDialogue(gameState, playerParty[playerLead].name)
        if gameState.timer >= 1.5 then
            gameState.phase = "main"
            gameState.timer = 0
        end
    end
    -- NOTES FOR TOMORROW - add logic for switching player, clean up game phase and action manip 
end