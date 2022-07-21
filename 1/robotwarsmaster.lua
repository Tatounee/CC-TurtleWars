require("utils")

local event, id

-- ---------------- "Equipe" le modem ajouté sur l'ordinateur --------------- --
local modem = peripheral.find("modem")
if not modem then
	error("No modem found", 2)
end
rednet.open(peripheral.getName(peripheral.find("modem")))

-- ----------- Setup les différents protocols (ordinateur/turtle) ----------- --
rednet.host("robotwars", "master")
rednet.host("robotwars_turtleNetwork", "master")

-- -------------- Attend que les ordinateurs/turtles soit lancé ------------- --
-- ---------------- Presser <ENTER> pour commencer la partie ---------------- --
local computers = {}
local function wait_for_computer_connections()
	while true do
		computers = { rednet.lookup("robotwars") }

		os.sleep(1)
	end
end

local turtles = {}
local function wait_for_turtle_connections()
	while true do
		turtles = { rednet.lookup("robotwars_turtleNetwork") }

		os.sleep(1)
	end
end

local function wait_for_enter()
	repeat
		local _, key = os.pullEvent("key")
	until key == keys.enter
end

parallel.waitForAny(wait_for_computer_connections, wait_for_turtle_connections, wait_for_enter)

-- ---------- Retire l'ordinateur master des controleurs et turtles --------- --
local function id_is_not_master(_, id)
	return id ~= os.getComputerID()
end
print("#c = ", #computers)
table.iretain(computers, id_is_not_master)
print("#c_ = ", #computers)
table.iretain(turtles, id_is_not_master)

-- ----------------- Créer les joueurs (ordinateur + turtle) ----------------- --
-- TODO: check si il n'y a qu'un seul joueur en lice
local players = {}
local players_count = 0
if #turtles ~= #computers then
	error("Nombre de controleur (" .. #turtles .. ") et de robot (" .. #computers .. ") différent.", 2)
else
	for i = 1, #computers do
		players_count = players_count + 1
		players[computers[i]] = turtles[i]
	end
end
print(players_count .. " joueurs en lice.")

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
