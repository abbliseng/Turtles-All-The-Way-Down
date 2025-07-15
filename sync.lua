local version = tostring(os.epoch("utc"))
local baseUrl = "https://raw.githubusercontent.com/abbliseng/Turtles-All-The-Way-Down/main/"
CACHE_FOLDER = ".cache"
CACHE_FILE = CACHE_FOLDER .. "/.versions"
CACHED_VERSIONS = {}

function Download(fileName)
    local cachedVersion = GetCachedVersion(fileName)
    local url = baseUrl .. fileName
    local response = http.get(url)
    -- TODO: Chache
    if response ==nil or response.getResponseCode() ~= 200 then
        print("Unable to open url: " .. fileName)
        return
    end

    local onlineVersion = cachedVersion
    if response ~= nil then
        local versionStr = response.readLine()
        onlineVersion = string.match(versionStr, "--%s*Version:%s*(%S*)%s*--")
        if onlineVersion == nil then
            onlineVersion = MISSING_VERSION
        end
    end

    if (cachedVersion ~= onlineVersion or onlineVersion == MISSING_VERSION) then
        if onlineVersion ~= MISSING_VERSION then
            printf("Downloading updated version %s.", onlineVersion)
        end
        print("Downloading updated version of " .. fileName)
        fileCode = response.readAll()
        local savefile = fs.open(fileName, "w")
        savefile.write(fileCode)
        savefile.flush()
        savefile.close()

        SetCachedVersion(fileName, onlineVersion)
        print("Download complete.")
    end

    if response ~= nil then
        response.close()
    end
end

function SetCachedVersion(fileName, version)
    local function serializeCacheVersion(key, value)
        return string.format("[\"%s\"]=\"%s\"", key, value)
    end

    local function map(f, array)
        local ret = {}
        for k, v in pairs(array) do
            table.insert(ret, f(k, v))
        end

        return ret
    end

    CACHED_VERSIONS[fileName] = version
    local cachefile = fs.open(CACHE_FILE, 'w')
    cachefile.writeLine("VERSIONS = {")
    local keys = map(serializeCacheVersion, CACHED_VERSIONS)
    cachefile.writeLine(table.concat(keys, ',\n'))
    cachefile.writeLine("}")
    cachefile.close()
end

function GetCachedVersion(fileName)
    local foundVersion = "none"
    if not fs.exists(CACHE_FILE) then
        return foundVersion
    end

    local file = fs.open(CACHE_FILE, 'r')
    local line = nil
    while true do
        line = file.readLine()
        if line == nil then
            break
        end

        local pattern = ".*\"(%S*)\".*=\"(%S*)\""
        local url, version = string.match(line, pattern)

        if url ~= nil and version ~= nil then
            -- printf("File: %s => %s", url, version)
            CACHED_VERSIONS[url] = version;
        end

        if (url == fileName) then
            foundVersion = version
        end
    end

    file.close()
    return foundVersion
end

print("Syncing...")
Download("files.txt")

print("Sync complete!")
