-- Code along target clicker game tutorial from https://www.youtube.com/watch?v=wttKHL90Ank

-- global variables such as windows size, default is 800x600
function love.load()
    target = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = 50,
    }

    score = 0
    timer = 0
    gameFont = love.graphics.newFont(40);
end

-- updates every frame (default 60fps)
function love.update(dt)
    timer = timer + 1/60;
    
end

-- drawing graphics on the screen - essentially everything the players see - dont include calculations in this function, also updates every frame
function love.draw()
    love.graphics.setColor(1, 0.7, 0.4);
    love.graphics.circle("fill", target.x, target.y, target.radius);

    love.graphics.setColor(1, 1, 1);
    love.graphics.setFont(gameFont);
    love.graphics.print(score, 0, 0);
    love.graphics.print(string.format("%.1f", timer), 0, 40);
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        local mouseToTarget = findDistance(x, y, target.x, target.y);
        if mouseToTarget < target.radius then
            score = score + 1;
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius);
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius);
            target.radius = math.random(25, 75);
        end
    end
end

function findDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2);
end
