print("JOHANS startup...")
if fs.exists("JOHAN/consciousness.lua") then
    -- shell.run("JOHAN/consciousness.lua")
    multishell.launch({shell = shell}, "JOHAN/consciousness.lua")
else
    print("JOHAN/consciousness.lua not found, skipping...")
end

if fs.exists("JOHAN/monitor.lua") then
    -- shell.run("JOHAN/monitor.lua")
    multishell.launch({shell = shell}, "JOHAN/monitor.lua")
else
    print("JOHAN/monitor.lua not found, skipping...")
end


if fs.exists("JOHAN/ae/bees_reciever.lua") then
    multishell.launch({shell = shell}, "JOHAN/ae/bees_reciever.lua")
else
    print("JOHAN/ae/bees_reciever.lua not found, skipping...")
end

if fs.exists("JOHAN/ae/bees_requester.lua") then
    multishell.launch({shell = shell}, "JOHAN/ae/bees_requester.lua")
else
    print("JOHAN/ae/bees_requester.lua not found, skipping...")
end