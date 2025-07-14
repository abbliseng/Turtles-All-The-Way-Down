local baseUrl = "https://raw.githubusercontent.com/abbliseng/Turtles-All-The-Way-Down/main/"
local manifestUrl = baseUrl .. "files.txt"

print("Syncing...")

local response = http.get(manifestUrl)
if not response then
    print("ERROR: Failed to get manifest")
    return
end

local content = response.readAll()
response.close()

for line in string.gmatch(content, "[^\r\n]+") do
    local fullUrl = baseUrl .. line
    local localPath = line

    -- Check if file exists on GitHub
    if http.checkURL(fullUrl) then
        local dir = fs.getDir(localPath)
        if dir and not fs.exists(dir) then
            fs.makeDir(dir)
        end
        if fs.exists(localPath) then
            print("File exists, deleting: " .. localPath)
            fs.delete(localPath)
        end

        shell.run("wget " .. fullUrl .. " " .. localPath)
        print("Downloaded: " .. localPath)
    else
        print("Skipped (not found): " .. localPath)
    end
end

print("Sync complete!")
