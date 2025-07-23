rednet.open("back")

local function receiveAvailableItems()
    while true do
        local id, message = rednet.receive()
        print("Received message from ID " .. id .. ": " .. message)
    end
end

while true do
    local event, param = os.pullEvent()
    if event == "rednet_message" then
        local senderId, message = param[1], param[2]
        print("Received message from ID " .. senderId .. ": " .. message)
    end
end