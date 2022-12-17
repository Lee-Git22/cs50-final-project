Menu = require("Menu")

UI = {}

    function UI.drawBackground()
        -- Draws in background
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", borderSize, borderSize, winWidth - (borderSize*2), winHeight - total_height - (borderSize*2))
    end
    
    function UI.drawPlayer()
        love.graphics.setColor(0.7, 0.7, 0.7)

    end

    function UI.drawEnemy()
    
    end


return UI