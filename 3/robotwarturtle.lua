
local modem = peripheral.find("modem")
if not modem then
	error("No modem found", 2)
end
rednet.open(peripheral.getName(peripheral.find("modem")))

rednet.host("robotwars_turtleNetwork", "robot2")
local master = rednet.lookup("robotwars_turtleNetwork", "master")






