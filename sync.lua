local version = tostring(os.epoch("utc"))
local baseUrl = "https://raw.githubusercontent.com/abbliseng/Turtles-All-The-Way-Down/main/"
CACHE_FOLDER = ".cache"
CACHE_FILE = CACHE_FOLDER .. "/.versions"
CACHED_VERSIONS = {}

function Download(fileName)
    local url = baseUrl .. fileName
    local response = http.get(url)
    -- TODO: Chache
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
