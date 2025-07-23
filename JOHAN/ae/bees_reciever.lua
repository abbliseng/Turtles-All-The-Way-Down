rednet.open("back")

local function receiveAvailableItems()
    fs.open("bees_available_items.txt", "w")
    fs.write("bees_available_items.txt", message)
    fs.close("bees_available_items.txt")
end

while true do
    local event, sender, message, protocol = os.pullEvent("rednet_message")
    if sender == 4 then
        receiveAvailableItems()
    end
end
