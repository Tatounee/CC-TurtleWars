local sizeX = 5
local sizeY = 5

local modem = peripheral.find("modem")
if not modem then
    error("No modem found", 2)
end
rednet.open(peripheral.getName(peripheral.find("modem")))

rednet.host("robotwars", "robot1")

local computers = {rednet.lookup("chat")}

function loop()
    while true do
        turtle = {
            forward=function()
                
            end,
            back=function() 
                
            end,
            up=function() 
                
            end,
            down=function() end,
            turnLeft=function() end,
            turnRight=function() end,
            dig=function() end,
            digUp=function() end,
            digDown=function() end,
            place=function() end,
            placeUp=function() end,
            placeDown=function() end,
            drop=function() end,
            select=function() end,
            getItemCount=function() end,
            getItemSpace=function() end,
            detect=function() end,
        }
        coroutine.yield(turtle)
    end
end


while true do

    local event, data, message, protocol = os.pullEventRaw()
    if event == "terminate" then
        break
    elseif event == "rednet_message" and protocol == "robotwars" then
        print("Received message from " .. data .. " with message " .. tostring(message))
    elseif event == "rednet_message" and protocol == rednet.CHANNEL_BROADCAST then
        print("Received message from " .. data .. " with message " .. tostring(message))
    end
end

return turtle