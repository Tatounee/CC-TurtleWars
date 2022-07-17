-- Initialize external monitor, if one is found
monitor = peripheral.find("monitor")
if not monitor then
    monitor = {setBackgroundColor=function() end,setTextColor=function() end, clear=function() end, getSize=function() end, setCursorPos=function() end,write=function() end}
    monSizeX = 1000
    monSizeY = 1000
else
    monSizeX, monSizeY = monitor.getSize()
end
monitor.setBackgroundColor(colors.black)
monitor.clear()
term.setBackgroundColor(colors.gray)
term.clear()
--Initialize game size
termSizeX, termSizeY = term.getSize()
sizeX = math.min(monSizeX, termSizeX)
sizeY = math.min(monSizeY, termSizeY)-1
size = 3
paintutils.drawFilledBox(1, 1, sizeX, sizeY, colors.black)

actions = 1
score = 0

--setup game timer
gameInterval = 0.1
timerID = os.startTimer(gameInterval)

-- setup initial snake
local startX = math.floor(sizeX/2)
local startY = math.floor(sizeY/2)
snake = {{x=startX,y=startY},{x=startX-1,y=startY},{x=startX-2,y=startY},{x=startX-3,y=startY},{x=startX-4,y=startY}}
direction = {x=1,y=0}
apple = {x=1,y=1}

function closeGame()
    monitor.setCursorPos(startX-3, startY)
    monitor.setTextColor(colors.red)
    monitor.write("You Lost!")
    term.setCursorPos(startX-3, startY)
    term.setTextColor(colors.red)
    term.write("You Lost!")
    term.setCursorPos(1, 1)
end

function writeScore()
    monitor.setCursorPos(1, sizeY+1)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.write("Score : " .. score)
    term.setCursorPos(1, sizeY+1)
    term.setBackgroundColor(colors.gray)
    term.setTextColor(colors.white)
    term.write("Score : " .. score)
end

function drawToPos(x, y, color)
    monitor.setCursorPos(x, y)
    monitor.setBackgroundColor(color)
    monitor.write(" ")
    paintutils.drawPixel(x,y,color)
end

function IsSnakeHere(x,y)
    for index, part in ipairs(snake) do
        if part.x == x and part.y == y then
            return true
        end
    end
    return false
end

function createApple()
    repeat
        appleX = math.random(sizeX)
        appleY = math.random(sizeY)
    until not IsSnakeHere(appleX,appleY)
    apple.x = appleX
    apple.y = appleY
    drawToPos(appleX, appleY, colors.yellow)
end

-- setup initial apple
createApple()
writeScore()

-- Draw initial snake
for index, part in ipairs(snake) do
    drawToPos(part.x, part.y, colors.white)
end

--Fires when events are triggered
eventHandlers = {
    key = function(number, boolean)
        if boolean or actions < 1 then
            return true
        end
        if number == 200 and direction.y ~= 1 then
            direction = {x=0,y=-1}
            actions = actions -1
        elseif number == 208 and direction.y ~= -1 then
            direction = {x=0,y=1}
            actions = actions -1
        elseif number == 203 and direction.x ~= 1 then
            direction = {x=-1,y=0}
            actions = actions -1
        elseif number == 205 and direction.x ~= -1 then
            direction = {x=1,y=0}
            actions = actions -1
        end
        return true
    end,
    --Fires every gameInterval (ms)
    timer = function(id)
        if id == timerID then 
            -- create snake head
            local newHead = {x=snake[1].x+direction.x,y=snake[1].y+direction.y}
            -- Check if snake is eating itself
            if IsSnakeHere(newHead.x, newHead.y) then
                return false
            end
            if newHead.x > sizeX or newHead.y > sizeY or newHead.x < 1 or newHead.y < 1 then
                return false
            end
            -- Add snake head
            table.insert(snake, 1, newHead)
            drawToPos(newHead.x, newHead.y, colors.white)
            -- Check if snake is eating apple
            if newHead.x == apple.x and newHead.y == apple.y then
                score = score +1
                createApple()
                writeScore()
            else 
                -- Remove last element of snake
                local removed = table.remove(snake)
                drawToPos(removed.x, removed.y, colors.black)
            end
            timerID = os.startTimer(gameInterval)
            actions = 1
        end
        return true
    end
}

-- game loop
while true do 
    local event, data, additional = os.pullEventRaw()
    if event == "terminate" then 
        closeGame()
        break
    else 
        logic = eventHandlers[event]
        if logic then
            if not logic(data, additional) then
            closeGame()
            break
            end
        end
    end
end