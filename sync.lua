local version = tostring(os.epoch("utc"))
local baseUrl = "https://api.github.com/repos/abbliseng/Turtles-All-The-Way-Down/contents/"
CACHE_FOLDER = ".cache"
CACHE_FILE = CACHE_FOLDER .. "/.versions"
CACHED_VERSIONS = {}

function Download(fileName)
    local url = baseUrl .. fileName .. "?ref=main"
    local headers = {
        ["User-Agent"] = "Turtles All The Way Down Sync",
        ["Accept"] = "application/vnd.github.v3+json"
    }
    local response = http.get(url, headers)
    if response ==nil or response.getResponseCode() ~= 200 then
        print("Unable to open url: " .. fileName)
        return
    end
    print("Downloading updated version of " .. fileName)
    fileCode = response.readAll()
    local savefile = fs.open(fileName, "w")
    savefile.write(fileCode)
    savefile.flush()
    savefile.close()
end

print("Syncing...")
Download("files.txt")

print("Sync complete!")
