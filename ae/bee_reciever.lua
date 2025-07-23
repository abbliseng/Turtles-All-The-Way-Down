local get_available_items_timer = os.startTimer(5)
ae_reader = peripheral.wrap("me_bridge_2")

items = ae_reader.getItems()
print("Items: " .. #items)

-- rednet.open("top")
-- local id, message = rednet.receive()
-- print("Received message from ID " .. id .. ": " .. message)

-- while true do
--     local event, param = os.pullEvent()
--     if event == "timer" and param == get_available_items_timer then
--         -- rednet.send(6, "get_available_items")
--         get_available_items_timer = os.startTimer(5)
--     end
-- end