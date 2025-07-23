rednet.open("top")
local ae_reader = peripheral.wrap("me_bridge_3")


-- while true do
    local event, sender, message, protocol = os.pullEvent("rednet_message")
    if sender == 4 then
        print(message)
        message = textutils.unserialize(message)
        for key, item in pairs(message) do
            ae_reader.exportItem(item, "down")
        end
    end
-- end