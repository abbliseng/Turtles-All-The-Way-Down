rednet.open("top")
local ae_reader = peripheral.wrap("me_bridge_3")


while true do
    local event, sender, message, protocol = os.pullEvent("rednet_message")
    if sender == 4 then
        message = textutils.unserialize(message)
        print(message)
        for key, item in pairs(message) do
            print(item.displayName)
        end
    end
end