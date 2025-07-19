local baseUrl = "https://api.github.com/repos/abbliseng/Turtles-All-The-Way-Down/contents/"

function Download(fileName)
    local url = baseUrl .. fileName .. "?ref=main"
    local headers = {}
    if fs.exists("secrets.txt") then
        local secrets = fs.open("secrets.txt", "r")
        local secretToken = secrets.readLine()
        secrets.close()

        headers = {
            ["Cache-Control"] = "no-cache",
            ["Accept"] = "application/vnd.github.v3.raw",
            ["Authorization"] = "Bearer " .. secretToken
        }
    else
        headers = {
            ["Cache-Control"] = "no-cache",
            ["Accept"] = "application/vnd.github.v3.raw",
        }
    end
    local response = http.get(url, headers)
    if response == nil or response.getResponseCode() ~= 200 then
        print("Unable to open url: " .. fileName)
        return
    end
    fileCode = response.readAll()
    local savefile = fs.open(fileName, "w")
    savefile.write(fileCode)
    savefile.flush()
    savefile.close()
end

function DownloadAllFiles(fileListName)
    local fileList = fs.open(fileListName, "r")
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
DownloadAllFiles("files.txt")
if fs.exists("local_files.txt") then
    DownloadAllFiles("local_files.txt")
end
print("Sync complete!")
