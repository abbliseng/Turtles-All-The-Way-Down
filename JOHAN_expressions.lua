-- print out all redstone relay peripherals
local peripherals = peripheral.getNames()
local count = 0
for _, name in ipairs(peripherals) do
    if peripheral.getType(name) == "redstone_relay" then
        count = count + 1
        print(name)
    end
end

-- print out the total number of redstone relays
print("Total redstone relays: " .. count)
print("Total redstone relays: " .. count)