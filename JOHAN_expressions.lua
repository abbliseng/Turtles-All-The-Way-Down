-- print out all redstone relay peripherals
local peripherals = peripheral.getNames()
local count = 0
for _, name in ipairs(peripherals) do
    if peripheral.getType(name) == "redstone_relay" then
        count = count + 1
    end
end

print("Total redstone relays: " .. count)

local function setAllRedstoneRelays(state)
    for _, name in ipairs(peripherals) do
        if peripheral.getType(name) == "redstone_relay" then
            peripheral.call(name, "setOutput", state)
        end
    end
end

local function toggleRedstoneRelays()
    local currentState = peripheral.call(peripherals[1], "getOutput")
    local newState = not currentState
    setAllRedstoneRelays(newState)
    print("Toggled all redstone relays to: " .. tostring(newState))
end

setAllRedstoneRelays(false)  -- Turn off all relays initially
print("All redstone relays turned off.")
toggleRedstoneRelays()  -- Toggle the state of all relays
print("All redstone relays toggled.")