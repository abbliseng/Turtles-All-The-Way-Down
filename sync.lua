-- sync.lua
print("Hello from sync.lua!")

local baseUrl = "https://raw.githubusercontent.com/abbliseng/Turtles-All-The-Way-Down/main/"
local manifest = "https://raw.githubusercontent.com/abbliseng/Turtles-All-The-Way-Down/main/files.txt"

if http.checkURL(manifest) then
    local response = http.get(manifest)
    local content = response.readAll()
    response.close()

    for line in string.gmatch(content, "[^\r\n]+") do
        local fullUrl = baseUrl .. line
        local resp = http.checkURL(fullUrl)
        if not resp then
            print("File not found: " .. fullUrl)
            goto continue
        end
        local localPath = line
        -- Create folder structure if needed
        if string.find(localPath, "/") then
            shell.run("mkdir", fs.getDir(localPath))
        end
        shell.run("wget", "-f", fullUrl, localPath)
        print("Downloaded: " .. line)
    end
else
    print("Could not fetch manifest")
end

::continue::
print("Sync complete!")
