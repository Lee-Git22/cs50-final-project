backgroundHeight = winHeight - totalMenuHeight - (borderSize*2)
backgroundWidth = winWidth - (borderSize*2)

playerSprite = love.graphics.newImage("sprites/player.png")
cpuSprite = love.graphics.newImage("sprites/cpu.png")

UI = {}

    function UI.drawBackground()
        -- Draws in background
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.rectangle("fill", borderSize, borderSize, backgroundWidth, backgroundHeight)
    end
    
    function UI.drawPlayer()
        -- Draws player monster stats
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


        -- Loads player sprite
        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.draw(playerParty[playerLead].sprite1, borderSize, 8, 0, 4)

        
    end

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


        -- Loads cpu sprite
        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.draw(cpuParty[cpuLead].sprite2, winWidth-borderSize-320,borderSize+40,0,2.2)


        
        
    end


return UI