local timerInterval = 1
local event, id

local modem = peripheral.find("modem")
if not modem then
	error("No modem found", 2)
end
rednet.open(peripheral.getName(peripheral.find("modem")))

rednet.host("robotwars", "master")
rednet.host("robotwars_turtleNetwork", "master")

local computers = { rednet.lookup("robotwars") }
print(#computers .. " computers available")
for _, computer in pairs(computers) do
	print("Computer #" .. computer)
end

-- ------------------------ Fonction de boucle de jeu ----------------------- --
local instructions = {}
local function gameLoop()
	while true do
		rednet.broadcast("next turn", "robotwars")

		for turtle_id, action in pairs(instructions) do
			print("<" .. turtle_id .. "> do : " .. tostring(action))
		end
		print("============ Next turn ============")
		instructions = {}

		coroutine.yield(os.startTimer(timerInterval))
	end
end

-- ------------------------- Démare la boucle de jeu ------------------------ --
local timerID = os.startTimer(timerInterval)
local Loop = coroutine.create(gameLoop)

-- -------------------- Traite les requêtes sur le réseau ------------------- --
while true do
	local event, data, message, protocol = os.pullEventRaw()
	if event == "terminate" then
		break
	elseif event == "timer" and data == timerID then
		_, timerID = coroutine.resume(Loop)
	elseif event == "rednet_message" then
		-- print("[" .. (protocol or "\\") .. "] " .. data .. " : " .. tostring(message))
		if protocol == "robotwars" then
			-- print("Message from [" .. data .. "] to <" .. players[data] .. "> : " .. tostring(message))
			instructions[tostring(data)] = message
		end
	end
end
