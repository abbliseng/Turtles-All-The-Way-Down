-- startup.lua
print("Starting Turtles All The Way Down...")
shell.run("sync.lua")
-- if the JOHAN startup script is present, run it
if fs.exists("JOHAN/startup.lua") then
    shell.run("JOHAN/startup.lua")
end
print("Ready to go!")
