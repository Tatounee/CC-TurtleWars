local sizeX = 5
local sizeY = 5

local modem = peripheral.find("modem")
if not modem then
    error("No modem found", 2)
end
rednet.open(peripheral.getName(peripheral.find("modem")))

rednet.host("robotwars", "robot1")
local master = rednet.lookup("robotwars","master")
local turtle = {
    forward=function()
        repeat
            local id, message = rednet.receive("robotwars")
        until message == "next turn"
    end,
    back=function() 
        repeat
            local id, message = rednet.receive("robotwars")
        until message == "next turn"
    end,
    turnLeft=function()
        repeat
            local id, message = rednet.receive("robotwars")
        until message == "next turn"
    end,
    turnRight=function()
        repeat
            local id, message = rednet.receive("robotwars")
        until message == "next turn"
    end,
    dig=function()
        repeat
            local id, message = rednet.receive("robotwars")
        until message == "next turn"
    end,
    place=function()
        repeat
            local id, message = rednet.receive("robotwars")
        until message == "next turn"
    end,
    drop=function()
        repeat
            local id, message = rednet.receive("robotwars")
        until message == "next turn"
    end,
    select=function()
    end,
    getItemCount=function()
    end,
    detect=function()
    end,
    inspect=function()
    end,
		rednet.send(master, "forward", "robotwars")
		rednet.send(master, "back", "robotwars")
		rednet.send(master, "turnLeft", "robotwars")
		rednet.send(master, "turnRight", "robotwars")
		rednet.send(master, "dig", "robotwars")
		rednet.send(master, "place", "robotwars")
		rednet.send(master, "drop", "robotwars")
		rednet.send(master, "select", "robotwars")
		rednet.send(master, "getItemCount", "robotwars")
		rednet.send(master, "detect", "robotwars")
		rednet.send(master, "inspect", "robotwars")
}

function gameLoop()
    while true do
        local id, message = rednet.recieve("robotwars")
        print( id, message)
    end
end

local Loop = coroutine.create(gameLoop)
coroutine.resume(Loop)

return turtle