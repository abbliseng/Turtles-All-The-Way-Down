-- print out all redstone relay peripherals
local peripherals = peripheral.getNames()
local count = 0
local lowest_id = 0
for _, name in ipairs(peripherals) do
    if peripheral.getType(name) == "redstone_relay" then
        count = count + 1
        local id = tonumber(string.match(name, "%d+"))
        if id and (lowest_id == 0 or id < lowest_id) then
            lowest_id = id
        end
    end
end

print("Total redstone relays: " .. count)
print("Lowest ID: " .. lowest_id)

local function setAllRedstoneRelays(state)
    for _, name in ipairs(peripherals) do
        if peripheral.getType(name) == "redstone_relay" then
            relay = peripheral.wrap(name)
            relay.setOutput("front", state)
        end
    end
end

local function toggleRedstoneRelays()
    for _, name in ipairs(peripherals) do
        if peripheral.getType(name) == "redstone_relay" then
            relay = peripheral.wrap(name)
            local currentState = relay.getOutput("front")
            relay.setOutput("front", not currentState)
        end
    end
end

local function turnOnRedstoneRelay(id)
    -- turns on the redstone relay with the given id
    local relayName = "redstone_relay_" .. (id + lowest_id)
    if peripheral.isPresent(relayName) then
        relay = peripheral.wrap(relayName)
        relay.setOutput("front", true)
    else
        print("Relay " .. relayName .. " not found.")
    end
end

local function turnOnRedstoneRelays(ids)
    -- takes in a list och ids and turns on the relays with those ids at the end of their names
    for _, id in ipairs(ids) do
        relayName = "redstone_relay_" .. (id + lowest_id)
        if peripheral.isPresent(relayName) then
            relay = peripheral.wrap(relayName)
            relay.setOutput("front", true)
        else
            print("Relay " .. relayName .. " not found.")
        end
    end
end

-- Read a 24-bit BMP file and return pixel color values as a 2D array
function readBMP(path)
    local f = fs.open(path, "rb")
    if not f then error("File not found: " .. path) end

    local data = f.readAll()
    f.close()

    local function u32(offset)
        local b1 = string.byte(data, offset + 1)
        local b2 = string.byte(data, offset + 2)
        local b3 = string.byte(data, offset + 3)
        local b4 = string.byte(data, offset + 4)
        return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
    end

    local function u16(offset)
        local b1 = string.byte(data, offset + 1)
        local b2 = string.byte(data, offset + 2)
        return b1 + b2 * 256
    end

    if data:sub(1, 2) ~= "BM" then
        error("Not a BMP file")
    end

    local pixelDataOffset = u32(10)
    local width = u32(18)
    local height = u32(22)
    local bitsPerPixel = u16(28)

    if bitsPerPixel ~= 24 and bitsPerPixel ~= 32 then
        error("Only 24-bit or 32-bit BMP supported (got " .. bitsPerPixel .. "-bit)")
    end

    local bytesPerPixel = bitsPerPixel / 8
    local rowSize = math.floor((bitsPerPixel * width + 31) / 32) * 4

    local pixels = {}

    for y = 0, height - 1 do
        local row = {}
        for x = 0, width - 1 do
            local offset = pixelDataOffset + y * rowSize + x * bytesPerPixel
            local b = string.byte(data, offset + 1)
            local g = string.byte(data, offset + 2)
            local r = string.byte(data, offset + 3)
            table.insert(row, { r = r, g = g, b = b })
        end
        table.insert(pixels, 1, row) -- flip Y axis since BMP stores bottom to top
    end

    return pixels
end

function readBMPFiltered(path)
    local f = fs.open(path, "rb")
    if not f then error("File not found: " .. path) end
    local data = f.readAll()
    f.close()

    local function u32(o)
        local b1 = string.byte(data, o + 1)
        local b2 = string.byte(data, o + 2)
        local b3 = string.byte(data, o + 3)
        local b4 = string.byte(data, o + 4)
        return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
    end

    local function u16(o)
        local b1 = string.byte(data, o + 1)
        local b2 = string.byte(data, o + 2)
        return b1 + b2 * 256
    end

    if data:sub(1, 2) ~= "BM" then error("Not a BMP file") end

    local offset = u32(10)
    local width = u32(18)
    local height = u32(22)
    local bpp = u16(28)

    if bpp ~= 24 and bpp ~= 32 then error("Only 24-bit or 32-bit BMP supported") end

    local bppBytes = bpp / 8
    local rowSize = math.floor((bpp * width + 31) / 32) * 4

    local pixels = {}

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local pxOffset = offset + y * rowSize + x * bppBytes
            local b = string.byte(data, pxOffset + 1)
            local g = string.byte(data, pxOffset + 2)
            local r = string.byte(data, pxOffset + 3)

            if (r ~= 0 and g ~= 0 and b ~= 0) then
                -- Flip Y (top to bottom), flip X (left to right)
                local px = width - 1 - x
                local py = y
                local index = py * width + px
                pixels[index] = { r = r, g = g, b = b }
            end
        end
    end

    return pixels
end

setAllRedstoneRelays(false) -- Turn off all relays initially
file = fs.open("JOHAN/faces/neutral.bmp", "rb")
if file then
    local bmpData = file.readAll()
    file.close()
    print("BMP Data: " .. bmpData)
else
    print("Failed to open BMP file.")
end

local filteredPixels = readBMPFiltered("JOHAN/faces/neutral.bmp")
print("Filtered Pixels:")
for key, pixel in pairs(filteredPixels) do
    print(string.format("Pixel %d: R=%d, G=%d, B=%d", key, pixel.r, pixel.g, pixel.b))
    -- turn on the corresponding redstone relay
    turnOnRedstoneRelay(key)
end
