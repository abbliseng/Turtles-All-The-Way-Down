-- print out all redstone relay peripherals
local peripherals = peripheral.getNames()
-- sort the peripherals by their last number
table.sort(peripherals, function(a, b)
    local aNum = tonumber(string.match(a, "%d+$"))
    local bNum = tonumber(string.match(b, "%d+$"))
    return aNum < bNum
end)
for _, name in ipairs(peripherals) do
    if peripheral.getType(name) == "redstone_relay" then
        print(name)
    end
end