local timerInterval = 1
local event, id

local modem = peripheral.find("modem")
if not modem then
    error("No modem found", 2)
end
rednet.open(peripheral.getName(peripheral.find("modem")))

rednet.host("robotwars", "master")
rednet.host("robotwars_turtleNetwork", "master")

local computers = {rednet.lookup("robotwars")}
print(#computers .. " computers available")
for _, computer in pairs(computers) do
    print("Computer #" .. computer)
  end

function gameLoop()
    while true do
        rednet.broadcast("next turn", "robotwars")

        coroutine.yield(os.startTimer(timerInterval))
    end
end

local timerID = os.startTimer(timerInterval)
local Loop = coroutine.create(gameLoop)
while true do
    local event, data, message, protocol = os.pullEventRaw()
    if event == "terminate" then
        break
    elseif event == "timer" and data == timerID then
        _, timerID = coroutine.resume(Loop)
    elseif event == "rednet_message" then
        print( data .. " : " .. tostring(message))
    end
end