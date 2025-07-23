rednet.open("back")

local function receiveAvailableItems()
    while true do
        local id, message = rednet.receive()
        print("Received message from ID " .. id .. ": " .. message)
    end
end

while true do
    local event, sender, message, protocol = os.pullEvent("rednet_message")
    if protocol ~= nil then
        print("Received message from " .. sender .. " with protocol " .. protocol .. " and message " .. tostring(message))
    else
        print("Received message from " .. sender .. " with message " .. tostring(message))
    end
end
