-- startup.lua
print("Starting Turtles All The Way Down...")
print("Syncing...")
shell.run("syncer/sync.lua")
-- if the JOHAN startup script is present, run it
if fs.exists("JOHAN/startup.lua") then
    shell.run("JOHAN/startup.lua")
end
print("Ready to go!")
