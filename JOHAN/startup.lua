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
