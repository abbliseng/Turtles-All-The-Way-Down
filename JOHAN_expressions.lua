-- print out all redstone relay peripherals
local peripherals = peripheral.getNames()
-- sort the peripherals alphabetically
table.sort(peripherals)
for _, name in ipairs(peripherals) do
    if peripheral.getType(name) == "redstone_relay" then
        print(name)
    end
end