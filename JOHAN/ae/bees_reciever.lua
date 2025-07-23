rednet.open("back")

local function receiveAvailableItems(items)
    print("Synced at " .. os.date())
    local file = fs.open("JOHAN/ae/data/bees_available_items.txt", "w")
    for item in items do
        file.write(item .. "\n")
    end
    file.close()
end

while true do
    local event, sender, message, protocol = os.pullEvent("rednet_message")
    if sender == 6 then
        receiveAvailableItems(message)
    end
end
