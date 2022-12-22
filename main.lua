Menu = require("Menu")
UI = require("UI")
MonstersModule = require("MonstersModule")
ItemsModule = require("ItemsModule")
AttackModule = require("AttackModule")
Battle = require("Battle")
Sfx = require("Sfx")

-- Global menu tables to hold buttons
mainButtons = {}

MonstersIndex = {}
playerParty = {}
cpuParty = {}
AttackDataBase = {}
ItemDatabase = {}

-- Global values used for respective game state
gameState = {
    phase = "start",
    turn = "",
    message = "",
    playerInput = "", -- the move player chooses for the round
    computerInput = "", -- computers move for the round 
    timer = 0
}

function love.load()

    MonstersModule.load() -- Loads in monsters into MonstersIndex table
    AttackModule.load() -- Loads in database into Database table
    ItemsModule.load()

    Inventory = loadInventory(Inventory) -- Loads in items into Inventory table
    -- Options for main menu
    table.insert(mainButtons, Menu.newButton("FIGHT", function() gameState.phase = "fight" end))
    table.insert(mainButtons, Menu.newButton("ITEM", function() gameState.phase = "item" end))
    table.insert(mainButtons, Menu.newButton("PARTY", function() playSFX = true end)) 
    table.insert(mainButtons, Menu.newButton("QUIT", function() love.event.quit(0) end)) 
    
    
    loadPlayerParty()
    loadCpuParty()

    -- Sets first monster in party as party leader (default parameter)
    playerLead = 1 
    cpuLead = 1

    playerUI = false
    cpuUI = false

    
end

function love.update(dt)
    math.randomseed(love.mouse.getPosition()) -- for better RNG
    BGM()
    SFX(gameState)

    gameState.timer = gameState.timer + dt -- Used for menu display and to stop accidental double clicks

    -- Stats used for battle calculations for the current monsters in battle
    playerStats = {
        TYPE = playerParty[playerLead].stats.TYPE,
        HP = playerParty[playerLead].stats.HP - playerCombat.DMG,
        ATK = playerParty[playerLead].stats.ATK * playerCombat.ATK + itemBonus.ATK,
        DEF = playerParty[playerLead].stats.DEF * playerCombat.DEF + itemBonus.DEF,
        SPD = playerParty[playerLead].stats.SPD * playerCombat.SPD + itemBonus.SPD,
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
                    gameState.phase = "FAINT"
                else
                    gameState.phase = "playerAction"
                end
                gameState.timer = 0
                playSFX = true
                
            end
        end
    end

    if gameState.phase == "itemRound" then
        -- Change targets for battle message display
        Self = playerParty[playerLead]
        Opponent = cpuParty[cpuLead]

        for i, entry in pairs(ItemDatabase) do
            if gameState.playerInput == entry.name then
                

                
                if entry.TYPE == "HEAL" then -- Heals monster and updates gamestate message to HEAL
                    playerCombat.DMG = Heal(playerCombat.DMG, entry.value)
                elseif entry.TYPE == "RECRUIT" then -- Adds a number of monsters to party
                    Recruit(entry.value)
                
                elseif entry.TYPE == "TRADEOFF" then
                    if entry.name == "ATK BERRY" then
                        itemBonus.DEF, itemBonus.ATK = Tradeoff(itemBonus.DEF, itemBonus.ATK, (playerParty[playerLead].stats.DEF * 0.5), entry.value)
                    elseif entry.name == "DEF BERRY" then
                        itemBonus.SPD, itemBonus.DEF = Tradeoff(itemBonus.SPD, itemBonus.DEF, (playerParty[playerLead].stats.SPD * 0.5), entry.value)
                    elseif entry.name == "SPD BERRY" then
                        itemBonus.ATK, itemBonus.SPD = Tradeoff(itemBonus.SPD, itemBonus.SPD, (playerParty[playerLead].stats.ATK * 0.5), entry.value)
                    end
                    
                    
                end

                gameState.phase = "playerAction"
                gameState.timer = 0
                playSFX = true
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
                    gameState.phase = "FAINT"
                else
                    gameState.phase = "cpuAction"
                    gameState.turn = "player"  
                end

                gameState.timer = 0
                playSFX = true

            end
        end       
    end

    
    
end

function love.draw()

    -- Represents current button y position
    local cursorY = 0

    UI.drawBackground()
    
    if startingGameUI then
        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.draw(playerSprite, borderSize, 8, 0, 4)
        love.graphics.draw(cpuSprite, winWidth-borderSize-320,borderSize+40,0,2.2)
    end

    if playerUI then 
        UI.drawPlayer()
    end
    if cpuUI then
        UI.drawEnemy()
    end
    
    if gameState.phase == "start" then
        startingGameUI = true

        local leftClick = love.mouse.isDown(1)
        gameState.message = "start"
        Menu.loadDialogue(gameState) -- Straw Hat PETER wants to Battle
        
        if gameState.timer >= 10 or leftClick then -- After 10 seconds or leftclick, send out cpu monster
            
            startingGame = true
            gameState.message = "cpuswitch"
            gameState.phase = "cpuSelect"
            gameState.timer = 0

            
            
        end

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
                gameState.playerInput = moves -- Get players move
                gameState.computerInput = getCPUmove() -- Get computers move
                turn = 1

                -- Determines who turn 1 goes to 
                if playerStats.SPD >= cpuStats.SPD then
                    gameState.turn = "player"
                    gameState.phase = "dialogue"
                 else
                    gameState.turn = "cpu"
                    gameState.phase = "cpuDialogue"
                 end

                
            end

            local rightClick = love.mouse.isDown(2) 
            if rightClick and gameState.timer >= 0.3 then
                gameState.phase = "main"
                gameState.timer = 0
            end
            
            cursorY = cursorY + (BUTTON_HEIGHT + MARGIN)
        end
    end

    -- Switch to item menu 
    if gameState.phase == "item" then
        cursorY = 0
        
        -- Load the item menu
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

                gameState.playerInput = items.name

                if items.uses <= 0 then
                    items.uses = 0
                    gameState.message = "NO ITEM"
                    gameState.phase = "ERROR"
                else
                    gameState.message = "item"
                
                
                    gameState.computerInput = getCPUmove() -- Get computers move
    
                    turn = 1
                    -- When using item, player always goes first
                    gameState.turn = "player"
                    gameState.phase = "dialogue"
                    items.uses = items.uses - 1 
        
                    gameState.timer = 0
                end

            end

            local rightClick = love.mouse.isDown(2) 
            if rightClick and gameState.timer >= 0.3 then
                gameState.phase = "main"
                gameState.timer = 0
            end

            Menu.loadButton(buttonColor, string.format("%s x %s", items.name, items.uses), buttonX, buttonY, buttonWidth)
            
            cursorY = cursorY + (BUTTON_HEIGHT + MARGIN)
        end
    end

    if gameState.phase == "ERROR" then
        cursoyY = 0
        Menu.loadDialogue(gameState, nil, gameState.playerInput)
        
        -- Change this to be a keypress later
        if gameState.timer >= 1.5 then

            gameState.phase = "main"
            gameState.timer = 0

        end
    end

    if gameState.phase == "dialogue" then
        cursoyY = 0

        -- Displays Monster use X OR PLAYER used Y based on gameState.message
        Menu.loadDialogue(gameState, playerParty[playerLead].name, gameState.playerInput)
        
        -- Change this to be a keypress later
        if gameState.timer >= 1.5 then
            if gameState.message == "attack" then
                gameState.phase = "playerRound"
            else -- message would be "item"
                gameState.phase = "itemRound"
            end
            gameState.timer = 0

        end
    end

    if gameState.phase == "playerAction" then
        Menu.loadDialogue(gameState, playerParty[playerLead].name, gameState.playerInput)

        if gameState.timer >= 2 then
            
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

        startingGameUI = false -- hide trainer sprites

        if gameState.timer >= 0.5 then -- after 0.5
            if startingGame then -- send out first pokemon
                
                cpuLead = 1
                gameState.message = "cpuswitch"
                gameState.phase = "cpuswitch"
            else
                cpuCombat = resetCombat(cpuCombat) -- resets combat stats for next monster
                cpuLead = cpuLead + 1 -- shift party up by 1    
            end
           
            if cpuLead > cpuPartySize then
                cpuLead = 1
                gameState.message = "WIN"
                gameState.phase = "WIN"
                
            else
                cpuUI = true
                playSFX = true
                gameState.message = "cpuswitch"
                gameState.phase = "cpuswitch"
            end

            gameState.timer = 0
        end

    end

    if gameState.phase == "cpuswitch" then
        --displays CPU sends out X 
        Menu.loadDialogue(gameState, cpuParty[cpuLead].name)

        if gameState.timer >= 1.5 then 
            if startingGame then -- pass to player's first monster
                gameState.phase = "playerSelect"
            else -- just return to main
                gameState.phase = "main"
            end
            gameState.timer = 0
        end
        
       
    end
    
    if gameState.phase == "playerSelect" then
        if gameState.timer >= 0.5 then

            if startingGame then -- send out first pokemon
                playerLead = 1
            else
                playerCombat = resetCombat(playerCombat)
                playerLead = playerLead + 1
            end
            
            if playerLead > playerPartySize then
                playerLead = 1
                gameState.message = "LOSE"
                gameState.phase = "LOSE"
            else
                playerUI = true
                playSFX = true
                gameState.message = "playerswitch"
                gameState.phase = "playerswitch"
            end

            gameState.timer = 0
        end
    end

    if gameState.phase == "playerswitch" then
        --displays CPU sends out X 
        Menu.loadDialogue(gameState, playerParty[playerLead].name)
        if gameState.timer >= 1.5 then
            startingGame = false -- starting game finished
            gameState.phase = "main"
            gameState.timer = 0
        end
    end

    if gameState.phase == "WIN" then
        Menu.loadDialogue(gameState)

        if gameState.timer >= 1.5 then
            cpuUI = false
            playerUI = false
    
            startingGameUI = true
        end
    end

    if gameState.phase == "LOSE" then
        Menu.loadDialogue(gameState)
 
        if gameState.timer >= 1.5 then
            cpuUI = false
            playerUI = false
    
            startingGameUI = true
        end
    end
    
   
end