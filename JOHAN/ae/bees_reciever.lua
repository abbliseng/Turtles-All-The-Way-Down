rednet.open("back")

local function receiveAvailableItems()
    print("Synced at " .. os.date())
    local file = fs.open("JOHAN/ae/data/bees_available_items.txt", "w")
    file.write(message)
    file.close()
end

while true do
    local event, sender, message, protocol = os.pullEvent("rednet_message")
    if sender == 6 then
        receiveAvailableItems()
    end
end
