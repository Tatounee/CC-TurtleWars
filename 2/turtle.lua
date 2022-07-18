local sizeX = 5
local sizeY = 5

local modem = peripheral.find("modem")
if not modem then
	error("No modem found", 2)
end
rednet.open(peripheral.getName(peripheral.find("modem")))

rednet.host("robotwars", "robot1")
local master = rednet.lookup("robotwars", "master")

local turtle = {
	forward = function()
		rednet.send(master, "forward", "robotwars")
		repeat
			local id, message = rednet.receive("robotwars")
		until message == "next turn"
	end,
	back = function()
		rednet.send(master, "back", "robotwars")
		repeat
			local id, message = rednet.receive("robotwars")
		until message == "next turn"
	end,
	turnLeft = function()
		rednet.send(master, "turnLeft", "robotwars")
		repeat
			local id, message = rednet.receive("robotwars")
		until message == "next turn"
	end,
	turnRight = function()
		rednet.send(master, "turnRight", "robotwars")
		repeat
			local id, message = rednet.receive("robotwars")
		until message == "next turn"
	end,
	dig = function()
		rednet.send(master, "dig", "robotwars")
		repeat
			local id, message = rednet.receive("robotwars")
		until message == "next turn"
	end,
	place = function()
		rednet.send(master, "place", "robotwars")
		repeat
			local id, message = rednet.receive("robotwars")
		until message == "next turn"
	end,
	drop = function()
		rednet.send(master, "drop", "robotwars")
		repeat
			local id, message = rednet.receive("robotwars")
		until message == "next turn"
	end,
	select = function()
		rednet.send(master, "select", "robotwars")
	end,
	getItemCount = function()
		rednet.send(master, "getItemCount", "robotwars")
	end,
	detect = function()
		rednet.send(master, "detect", "robotwars")
	end,
	inspect = function()
		rednet.send(master, "inspect", "robotwars")
	end,
}

function gameLoop()
	while true do
		local id, message = rednet.recieve("robotwars")
		print(id, message)
	end
end

local Loop = coroutine.create(gameLoop)
coroutine.resume(Loop)

return turtle
