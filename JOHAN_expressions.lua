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

setAllRedstoneRelays(false)  -- Turn off all relays initially
print("All redstone relays turned off.")
happy_face = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
turnOnRedstoneRelays(happy_face)  -- Turn on all relays with ids 0-9