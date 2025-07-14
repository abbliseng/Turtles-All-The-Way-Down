local baseUrl = "https://raw.githubusercontent.com/abbliseng/Turtles-All-The-Way-Down/main/"

print("Syncing...")

if fs.exists("files.txt") then
    fs.delete("files.txt")
end
shell.run("wget", baseUrl .. "files.txt", "files.txt")

local file = fs.open("files.txt", "r")
local content = file.readAll()
file.close()
if not content then
    print("Failed to read files.txt")
    return
end

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
        -- print("Downloaded: " .. localPath)
    else
        print("Skipped (not found): " .. localPath)
    end
end

print("Sync complete!")
