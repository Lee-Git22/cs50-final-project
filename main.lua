-- Importing custom modules
Menu = require("Menu") -- For drawing messages and menus in the lower parts of the game
UI = require("UI") -- For drawing the battle phase UI and sprites
FightersModule = require("modules/FightersModule") -- The fighter data table that holds base stats and movesets
ItemsModule = require("modules/ItemsModule") -- The items data table 
AttackModule = require("modules/AttackModule") -- The attacks data table that details specific moveset parameters
Battle = require("Battle") -- Handles all battle related calculations and gamestate messages for results of each round
Sfx = require("Sfx") -- Holds info for sound effects used in battle

-- Global menu tables 
FightersIndex = {} 
AttackDataBase = {}
ItemDatabase = {}

mainButtons = {}
playerParty = {} 
cpuParty = {}

-- Global gameState table used to track game flow
gameState = {
    phase = "START", -- the general phase of the game, after start phase the game will loop back to main phase until the game is over
    turn = "", -- to keep track of who goes first
    message = "", -- for displaying the correct battle message
    playerInput = "", -- the move player chooses for the round
    computerInput = "", -- computers move for the round 
    timer = 0 -- used to track how long messages are displayed for
}

function love.load()

    -- Loads the respective modules
    FightersModule.load() 
    AttackModule.load() 
    ItemsModule.load() 
    Inventory = loadInventory(Inventory) -- Loads in items into Inventory table
    
    -- Options for main phase menu
    table.insert(mainButtons, Menu.newButton("FIGHT", function() gameState.phase = "FIGHT" end))
    table.insert(mainButtons, Menu.newButton("ITEM", function() gameState.phase = "ITEM" end))
    table.insert(mainButtons, Menu.newButton("HELP", function() gameState.phase = "HELP" end)) 
    table.insert(mainButtons, Menu.newButton("QUIT", function() love.event.quit(0) end)) 
    
    -- Calls loading party functions from battle module
    loadPlayerParty() 
    loadCpuParty()  
end

function love.update(dt)
    math.randomseed(love.mouse.getPosition()) -- for better pseudo RNG

    -- Updates correct SFX and BGM
    BGM()
    SFX(gameState) -- will play the correct SFX based on gameState.message

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

    -- Updates the moves for player
    playerList = {
        playerParty[playerLead].moveset.move1, 
        playerParty[playerLead].moveset.move2, 
        playerParty[playerLead].moveset.move3, 
        playerParty[playerLead].moveset.move4
    }
    
    -- For player round
    if gameState.phase == "PLAYERROUND" and gameState.turn == "PLAYER" then
        
        -- Sets perspective for battle messages
        Self = playerParty[playerLead]
        Opponent = cpuParty[cpuLead]

        for i, entry in pairs(AttackDataBase) do -- Look thru database for the attack selected
            if gameState.playerInput == entry.name then
                
                if entry.TYPE == "BUFF" then -- Returns gameState.message of "BUFF" or "MISS"
                    gameState, playerCombat = calcBuff(gameState, entry, playerCombat)
                    
                elseif entry.TYPE == "DEBUFF" then -- Returns gameState.message of "DEBUFF" or "MISS"
                    gameState, cpuCombat = calcBuff(gameState, entry, cpuCombat)
                    
                -- For all other attacks
                else -- Returns gameState.message of "SUPER EFFECTIVE!" "not very effective..." "FAINT" "MISS" or "RISKY"
                    gameState, entry, playerCombat, playerStats, cpuCombat, cpuStats = calcAttack(gameState, entry, playerCombat, playerStats, cpuCombat, cpuStats)
                end
                
                if gameState.message == "FAINT" then -- For killing blows, pivot to faint phase
                    gameState.phase = "FAINT"
                else
                    gameState.phase = "PLAYERACTION"
                end

                gameState.timer = 0 -- Resets timer for next message
                playSFX = true -- Plays a SFX based on whichever gameState.message was returned for the attack
                
            end
        end
    end

    -- If player used an item they will always go first
    if gameState.phase == "ITEMROUND" then
        
        Self = playerParty[playerLead]
        Opponent = cpuParty[cpuLead]

        for i, entry in pairs(ItemDatabase) do
            if gameState.playerInput == entry.name then
            
                if entry.TYPE == "HEAL" then -- Heals monster and updates gamestate message to HEAL
                    playerCombat.DMG = Heal(playerCombat.DMG, entry.value)

                elseif entry.TYPE == "RECRUIT" then 
                    Recruit(entry.value) -- Returns gamestate.message "RECRUIT"
                
                elseif entry.TYPE == "TRADEOFF" then -- Returns gameState.message "TRADEOFF"
                    if entry.name == "ATK BERRY" then
                        itemBonus.DEF, itemBonus.ATK = Tradeoff(itemBonus.DEF, itemBonus.ATK, (playerParty[playerLead].stats.DEF * 0.5), entry.value)
                    elseif entry.name == "DEF BERRY" then
                        itemBonus.SPD, itemBonus.DEF = Tradeoff(itemBonus.SPD, itemBonus.DEF, (playerParty[playerLead].stats.SPD * 0.5), entry.value)
                    elseif entry.name == "SPD BERRY" then
                        itemBonus.ATK, itemBonus.SPD = Tradeoff(itemBonus.SPD, itemBonus.SPD, (playerParty[playerLead].stats.ATK * 0.5), entry.value)
                    end  
                    
                end
                
                gameState.phase = "PLAYERACTION"
                gameState.timer = 0
                playSFX = true

            end 
        end
        
    end

    -- For CPU turn, mirrors a player round but with randomized move selection
    if gameState.phase == "CPUROUND" and gameState.turn == "CPU" then

        Self = cpuParty[cpuLead]
        Opponent = playerParty[playerLead]

        for i, entry in pairs(AttackDataBase) do
            if gameState.computerInput == entry.name then
                
                if entry.TYPE == "BUFF" then
                    gameState, cpuCombat = calcBuff(gameState, entry, cpuCombat)

                elseif entry.TYPE == "DEBUFF" then                   
                    gameState, playerCombat = calcBuff(gameState, entry, playerCombat)
                    
                else 
                    -- For attacks
                    gameState, entry, cpuCombat, cpuStats, playerCombat, playerStats = 
                    calcAttack(gameState, entry, cpuCombat, cpuStats, playerCombat, playerStats)
                end

                if gameState.message == "FAINT" then
                    gameState.phase = "FAINT"
                else
                    gameState.phase = "CPUACTION"
                    gameState.turn = "PLAYER"  
                end

                gameState.timer = 0
                playSFX = true

            end
        end       
    end

end

function love.draw()

    UI.drawBackground()
    
    -- For starting the game
    if startingGameUI then
        love.graphics.setColor(0.8,0.8,0.9)
        love.graphics.draw(playerSprite, borderSize, 8, 0, 4) -- Draw player sprite
        love.graphics.draw(cpuSprite, winWidth-borderSize-320,borderSize+40,0,2.2) -- Draw CPU sprite
    end

    -- If Fighters are sent out, display their HP and sprites
    if playerUI then 
        UI.drawPlayer()
    end
    if cpuUI then
        UI.drawEnemy()
    end
    
    -- Initial gamephase/cutscene
    if gameState.phase == "START" then
        startingGameUI = true -- Keeps trainer sprites up

        -- 
        local leftClick = love.mouse.isDown(1)

        gameState.message = "START"
        Menu.loadDialogue(gameState) -- Will Display "Straw Hat PETER wants to Battle"

        -- After 10 seconds or leftclick, send out cpu monster
        if gameState.timer >= 10 or leftClick then 
            love.audio.play(clicksfx)

            startingGame = true -- Used for sending out first pokemon
            gameState.phase = "CPUSELECT" -- Go to next phase - CPU Sents out fighter first
            gameState.timer = 0
        end

    end

    -- The phase where CPU Selects its next fighter
    if gameState.phase == "CPUSELECT" then
        startingGameUI = false -- hide trainer sprites, the game has started

        if gameState.timer >= 0.5 then -- after 0.5s
            if startingGame then -- send out first pokemon
                cpuLead = 1
            else
                cpuCombat = resetCombat(cpuCombat) -- resets combat stats for next monster
                cpuLead = cpuLead + 1 -- shift party up by 1    
            end
           
            if cpuLead > cpuPartySize then -- No more fighters left
                cpuLead = 1 -- Reset to prevent index error
                gameState.message = "WIN"
                gameState.phase = "WIN"
                
            else
                cpuUI = true
                playSFX = true
                gameState.message = "CPUSELECT"
                gameState.phase = "CPUSWITCH"
                

            end
            gameState.timer = 0
        end
    end

    -- Transitionary phase to pass back to playerselect for first turn or back to main
    if gameState.phase == "CPUSWITCH" then
        
        --displays CPU sends out X from gameState.message "cpuselect"
        Menu.loadDialogue(gameState, cpuParty[cpuLead].name)

        if gameState.timer >= 1.5 then -- After 1.5s,
            if startingGame then -- pass to player's first monster
                gameState.phase = "PLAYERSELECT"
            else -- just return to main
                gameState.phase = "MAIN"
            end
            gameState.timer = 0
        end
    end

    -- Player Selects a pokemon for this phase, mirrors cpuselect
    if gameState.phase == "PLAYERSELECT" then
        if gameState.timer >= 0.5 then

            if startingGame then -- send out first pokemon
                playerLead = 1
            else -- otherwise send next one
                playerCombat = resetCombat(playerCombat)
                playerLead = playerLead + 1
            end
            
            if playerLead > playerPartySize then
                playerLead = 1 -- Reset to prevent index error
                gameState.message = "LOSE"
                gameState.phase = "LOSE"
            else
                playerUI = true
                playSFX = true
                gameState.message = "PLAYERSELECT"
                gameState.phase = "PLAYERSWITCH"
            end

            gameState.timer = 0
        end
    end

    -- Also transitionary phase back to main 
    if gameState.phase == "PLAYERSWITCH" then

        --displays Player sends out X 
        Menu.loadDialogue(gameState, playerParty[playerLead].name)

        if gameState.timer >= 1.5 then
            startingGame = false -- starting game finished
            gameState.phase = "MAIN"
            gameState.timer = 0
        end
    end

    -- The main phase where player selects the action for the round
    if gameState.phase == "MAIN" then
        local cursorY = 0 -- Represents current y position for drawing buttons
        
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
            if leftClick and hot and gameState.timer >= 0.3 then -- timer 0.3s to prevent double clicking
                gameState.timer = 0
                button.fn()
                love.audio.play(clicksfx)
            end

            -- Move cursor to prepare for next button
            cursorY = cursorY + (BUTTON_HEIGHT + MARGIN)
        end
    end

    -- Switch to Fight phase and draw menus
    if gameState.phase == "FIGHT" then
        local cursorY = 0

        -- Draws buttons in same way for main menu
        for i, moves in ipairs(playerList) do
            local buttonX = (winWidth) * 0.6
            local buttonWidth = (winWidth) * 0.4 - borderSize
            local buttonY = (winHeight) - (totalMenuHeight) + cursorY
            local buttonColor = {0.9, 0.9, 0.9, 1.0}

            local mx, my = love.mouse.getPosition()
            local hot = mx > buttonX and mx < winWidth and my > buttonY and my < buttonY + BUTTON_HEIGHT;
            if hot then
                buttonColor = {0.4, 0.4, 0.4, 1}
            end

            local leftClick = love.mouse.isDown(1)           
            if leftClick and hot and gameState.timer >= 0.3 then
                love.audio.play(clicksfx)

                gameState.message = "ATTACK" -- For displaying attack message "FIGHTER used MOVE"
                gameState.playerInput = moves -- Get players move
                gameState.computerInput = getCPUmove() -- Get computers move
                
                turn = 1 -- Tracks turn number
                -- Determines who turn 1 goes to 
                if playerStats.SPD >= cpuStats.SPD then
                    gameState.turn = "PLAYER"
                    gameState.phase = "DIALOGUE"
                else
                    gameState.turn = "CPU"
                    gameState.phase = "CPUDIALOGUE"
                end

                gameState.timer = 0
            end

            -- For going back to main menu
            local rightClick = love.mouse.isDown(2) 
            if rightClick and gameState.timer >= 0.3 then
                love.audio.play(clicksfx)
                gameState.phase = "MAIN"
                gameState.timer = 0
            end

            Menu.loadButton(buttonColor, moves, buttonX, buttonY, buttonWidth)
            cursorY = cursorY + (BUTTON_HEIGHT + MARGIN)
        end
    end

    -- Switch to item menu 
    if gameState.phase == "ITEM" then
        local cursorY = 0
        
        -- Draws the item buttons same way for main/fight buttons
        for i, items in ipairs(Inventory) do  
            
            local buttonX = (winWidth * 0.6) 
            local buttonWidth = (winWidth) * 0.4 - borderSize
            local buttonY = (winHeight) - (totalMenuHeight) + cursorY
            local buttonColor = {0.9, 0.9, 0.9, 1.0}

            local mx, my = love.mouse.getPosition()
            local hot = mx > buttonX and mx < winWidth and my > buttonY and my < buttonY + BUTTON_HEIGHT;
            if hot then
                buttonColor = {0.4, 0.4, 0.4, 1}
            end

            local leftClick = love.mouse.isDown(1) 
            if leftClick and hot and gameState.timer > 0.3 then
                love.audio.play(clicksfx)

                gameState.playerInput = items.name

                if items.uses <= 0 then -- Prevents player from using item with no uses
                    items.uses = 0
                    gameState.message = "NO ITEM"
                    gameState.phase = "ERROR"
                else
                    gameState.computerInput = getCPUmove() 
    
                    turn = 1
                
                    gameState.turn = "PLAYER" -- When using item, player always goes first
                    gameState.message = "ITEM"
                    gameState.phase = "DIALOGUE"
                    
                    items.uses = items.uses - 1 
                    gameState.timer = 0
                end

            end

            local rightClick = love.mouse.isDown(2) 
            if rightClick and gameState.timer >= 0.3 then
                love.audio.play(clicksfx)
                gameState.phase = "MAIN"
                gameState.timer = 0
            end

            Menu.loadButton(buttonColor, string.format("%s x %s", items.name, items.uses), buttonX, buttonY, buttonWidth)
            cursorY = cursorY + (BUTTON_HEIGHT + MARGIN)
        end
    end

    -- Displays Monster use X OR PLAYER used Y based on gameState.message
    if gameState.phase == "DIALOGUE" then   
        Menu.loadDialogue(gameState, playerParty[playerLead].name, gameState.playerInput)
        
        if gameState.timer >= 1.5 then
            if gameState.message == "ATTACK" then -- Transitionary dialogue phases depending on whether attack or item was selected from main phase
                gameState.phase = "PLAYERROUND" -- For battle calculations in love.update
            else 
                gameState.phase = "ITEMROUND" -- For item calculations in love.update
            end
            gameState.timer = 0
        end
    end
    if gameState.phase == "CPUDIALOGUE" then
        gameState.message = "CPUATTACK"
        Menu.loadDialogue(gameState, cpuParty[cpuLead].name, gameState.computerInput)
        
        if gameState.timer >= 1.5 then
            gameState.phase = "CPUROUND"
            gameState.timer = 0
        end
    end

    -- Displays the results of player or cpu action based on message from update function
    if gameState.phase == "PLAYERACTION" then
        Menu.loadDialogue(gameState, playerParty[playerLead].name, gameState.playerInput)

        if gameState.timer >= 2 then -- After 2 seconds go to turn 2 or reset
            if turn == 1 then
                gameState.phase = "CPUDIALOGUE"
                gameState.turn = "CPU"
                turn = 2 
            else 
                gameState.phase = "MAIN"
            end
            gameState.timer = 0
        end
    end
    if gameState.phase == "CPUACTION" then
        Menu.loadDialogue(gameState, cpuParty[cpuLead].name, gameState.computerInput)

        if gameState.timer >= 1.5 then
            if turn == 1 then 
                -- Go to player's turn and display player's attack message
                gameState.message = "ATTACK"
                gameState.phase = "DIALOGUE"
                gameState.turn = "PLAYER"
                turn = 2 -- update turn count
            else
                gameState.phase = "MAIN"
            end
            gameState.timer = 0
        end
    end

    -- For handling game flow when a fighter faints
    if gameState.phase == "FAINT" then       
        Menu.loadDialogue(gameState, Opponent.name) -- Displays X monster FAINTED 
        
        if gameState.timer >= 1.5 then
            -- Determine which side fainted and go to respective phase
            if cpuStats.HP == 0 then
                cpuUI = false -- for sprite transition 
                gameState.phase = "CPUSELECT" -- cpu switch   
            else 
                playerUI = false
                gameState.phase = "PLAYERSELECT" -- player switch
            end
            gameState.timer = 0 
        end
    end
    
    -- Displays Trainer sprites and end game screen result messages
    if gameState.phase == "WIN" then
        cpuUI = false
        playerUI = false
        if gameState.timer >= 1.0 then
            startingGameUI = true
            Menu.loadDialogue(gameState) 
        end
    end
    if gameState.phase == "LOSE" then
        cpuUI = false
        playerUI = false
        if gameState.timer >= 1.0 then
            startingGameUI = true
            Menu.loadDialogue(gameState)
        end
    end
    
    -- When player tries to use an item with no more uses
    if gameState.phase == "ERROR" then
        Menu.loadDialogue(gameState, nil, gameState.playerInput)
        
        -- Change this to be a keypress later
        if gameState.timer >= 1.0 then
            love.audio.play(clicksfx)
            gameState.phase = "MAIN"
            gameState.timer = 0
        end
    end

    -- Tutorial/Help screen
    if gameState.phase == "HELP" then
        gameState.message = "HELP"
        Menu.loadDialogue(gameState)
        local rightClick = love.mouse.isDown(2)
        if gameState.timer >= 10 or rightClick and gameState.timer >= 0.5 then
            love.audio.play(clicksfx)
            gameState.phase = "MAIN"
            gameState.timer = 0
        end
    end
   
end