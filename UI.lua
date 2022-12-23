backgroundHeight = winHeight - totalMenuHeight - (borderSize*2)
backgroundWidth = winWidth - (borderSize*2)

playerSprite = love.graphics.newImage("sprites/player.png")
cpuSprite = love.graphics.newImage("sprites/cpu.png")

playerUI = false
cpuUI = false

UI = {}
    -- Draws in grey background 
    function UI.drawBackground()
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.rectangle("fill", borderSize, borderSize, backgroundWidth, backgroundHeight)
    end

    -- Draws player fighter name and HP
    function UI.drawPlayer()

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", winWidth * 0.65 - borderSize, (backgroundHeight) * 0.80 + borderSize, winWidth * 0.35, backgroundHeight * 0.20)
        
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.print(
            string.format("%s", playerParty[playerLead].name), 
            font, 
            winWidth * 0.65 - borderSize, 
            (backgroundHeight) * 0.80 + borderSize
        )
        love.graphics.print(
            string.format("HP %s/%s", playerStats.HP, playerParty[playerLead].stats.HP),
            font, 
            winWidth * 0.65 - borderSize, 
            (backgroundHeight) * 0.90 + borderSize
        )

        -- Loads player fighter sprite
        love.graphics.setColor(0.8,0.8,0.9)
        love.graphics.draw(playerParty[playerLead].sprite1, borderSize, 8, 0, 4)
    end

    -- Draws CPU fighter name and HP
    function UI.drawEnemy()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", borderSize, borderSize, winWidth * 0.35, backgroundHeight * 0.20)
        
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.print(
            string.format("%s", cpuParty[cpuLead].name), 
            font, 
            borderSize, 
            borderSize
        )
        love.graphics.print(
            string.format("HP %s/%s", cpuStats.HP, cpuParty[cpuLead].stats.HP), 
            font, 
            borderSize, 
            backgroundHeight * 0.10 + borderSize
        )

        -- Loads cpu fighter sprite
        love.graphics.setColor(0.8,0.8,0.9)
        love.graphics.draw(cpuParty[cpuLead].sprite2, winWidth-borderSize-320,borderSize+40,0,2.2) 
    end
return UI