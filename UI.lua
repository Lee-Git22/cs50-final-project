Menu = require("Menu")

backgroundHeight = winHeight - totalMenuHeight - (borderSize*2)
backgroundWidth = winWidth - (borderSize*2)

UI = {}

    function UI.drawBackground()
        -- Draws in background
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", borderSize, borderSize, backgroundWidth, backgroundHeight)
    end
    
    function UI.drawPlayer()
        -- Draws player monster stats
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", winWidth * 0.65 - borderSize, (backgroundHeight) * 0.80 + borderSize, winWidth * 0.35, backgroundHeight * 0.20)
        
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.print(
            string.format("%s", playerParty[1].name), 
            font, 
            winWidth * 0.65 - borderSize, 
            (backgroundHeight) * 0.80 + borderSize
        )
        love.graphics.print(
            string.format("HP %s/%s", playerStats.HP, playerParty[1].stats.HP), --  Remember to change first arg to current HP
            font, 
            winWidth * 0.65 - borderSize, 
            (backgroundHeight) * 0.90 + borderSize
        )
        -- TODO: Load a sprite for playerParty[1]
    end

    function UI.drawEnemy()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", borderSize, borderSize, winWidth * 0.35, backgroundHeight * 0.20)
        
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.print(
            string.format("%s", computerParty[1].name), 
            font, 
            borderSize, 
            borderSize
        )
        love.graphics.print(
            string.format("HP %s/%s", computerStats.HP, computerParty[1].stats.HP), --  Remember to change first arg to current HP
            font, 
            borderSize, 
            backgroundHeight * 0.10 + borderSize
        )
        -- TODO: Load a sprite for enemyParty[1]
    end


return UI