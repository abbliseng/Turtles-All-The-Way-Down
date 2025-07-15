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

    -- Read the entire file into a binary string
    local data = f.readAll()
    f.close()

    -- Helper: read unsigned little-endian 4-byte int
    local function u32(offset)
        local b1 = string.byte(data, offset + 1)
        local b2 = string.byte(data, offset + 2)
        local b3 = string.byte(data, offset + 3)
        local b4 = string.byte(data, offset + 4)
        return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
    end

    -- Helper: read unsigned little-endian 2-byte int
    local function u16(offset)
        local b1 = string.byte(data, offset + 1)
        local b2 = string.byte(data, offset + 2)
        return b1 + b2 * 256
    end

    -- Validate header
    if data:sub(1, 2) ~= "BM" then
        error("Not a BMP file")
    end

    local pixelDataOffset = u32(10)
    local width = u32(18)
    local height = u32(22)
    local bitsPerPixel = u16(28)

    if bitsPerPixel ~= 24 then
        error("Only 24-bit BMP supported")
    end

    local rowSize = math.floor((bitsPerPixel * width + 31) / 32) * 4
    local pixels = {}

    for y = 0, height - 1 do
        local row = {}
        for x = 0, width - 1 do
            local offset = pixelDataOffset + y * rowSize + x * 3
            local b = string.byte(data, offset + 1)
            local g = string.byte(data, offset + 2)
            local r = string.byte(data, offset + 3)
            table.insert(row, { r = r, g = g, b = b })
        end
        table.insert(pixels, 1, row) -- BMP stores rows bottom to top
    end

    return pixels
end

setAllRedstoneRelays(false) -- Turn off all relays initially
print("All redstone relays turned off.")
neutral = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
turnOnRedstoneRelays(neutral) -- Turn on all relays with ids 0-9

-- read and print the bmp file
file = fs.open("JOHAN/faces/neutral.bmp", "rb")
if file then
    local bmpData = file.readAll()
    file.close()
    print("BMP Data: " .. bmpData)
else
    print("Failed to open BMP file.")
end

local pixels = readBMP("JOHAN/faces/neutral.bmp")
print("Width: " .. #pixels[1] .. ", Height: " .. #pixels)
for y = 1, #pixels do
    for x = 1, #pixels[y] do
        local pixel = pixels[y][x]
        -- Print pixel color values (r, g, b)
        print(string.format("Pixel at (%d, %d): R=%d, G=%d, B=%d", x, y, pixel.r, pixel.g, pixel.b))
    end
end