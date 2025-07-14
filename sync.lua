local baseUrl = "https://raw.githubusercontent.com/abbliseng/Turtles-All-The-Way-Down/main/"
local manifestUrl = baseUrl .. "files.txt"

print("Syncing...")

local response = http.get(manifestUrl)
if not response then
  print("Failed to get manifest!")
  return
end

local content = response.readAll()
response.close()

for line in string.gmatch(content, "[^\r\n]+") do
  local trimmedLine = string.gsub(line, "^%s*(.-)%s*$", "%1") -- remove leading/trailing spaces
  if trimmedLine ~= "" then
    local fullUrl = baseUrl .. trimmedLine
    local localPath = trimmedLine

    print(fullUrl)

    if http.checkURL(fullUrl) then
      local dir = fs.getDir(localPath)
      if dir and not fs.exists(dir) then
        fs.makeDir(dir)
      end

      -- PROTECTION: verify all args are strings
      if type(fullUrl) == "string" and type(localPath) == "string" then
        shell.run("wget", "-f", fullUrl, localPath)
        print("Downloaded: " .. localPath)
      else
        print("Skipped: bad filename or URL")
      end
    else
      print("Skipped (not found): " .. localPath)
    end
  end
end


print("Sync complete!")
