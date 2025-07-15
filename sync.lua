local baseUrl = "https://api.github.com/repos/abbliseng/Turtles-All-The-Way-Down/contents/"

function Download(fileName)
    local url = baseUrl .. fileName .. "?ref=main"
    local headers = {
        ["Cache-Control"] = "no-cache",
        ["Accept"] = "application/vnd.github.v3.raw"
    }
    local response = http.get(url, headers)
    if response ==nil or response.getResponseCode() ~= 200 then
        print("Unable to open url: " .. fileName)
        return
    end
    fileCode = response.readAll()
    local savefile = fs.open(fileName, "w")
    savefile.write(fileCode)
    savefile.flush()
    savefile.close()
end

function DownloadAllFiles()
    local fileList = fs.open("files.txt", "r")
    if not fileList then
        print("File list not found!")
        return
    end

    for fileName in fileList.readLine do
        if fileName ~= "" and not string.match(fileName, "^%s*---") then
            print("Downloading: " .. fileName)
            Download(fileName)
        end
    end

    fileList.close()
end
    

print("Syncing...")
Download("files.txt")
DownloadAllFiles()
print("Sync complete!")
