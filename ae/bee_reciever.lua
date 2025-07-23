local get_available_items_timer = os.startTimer(5)
ae_reader = peripheral.wrap("me_bridge_2")

items = ae_reader.getItems()
available_items = {}
for id, item in ipairs(items) do
    available_items[id] = item.displayName
end

print("Available items:")
for id, name in pairs(available_items) do
    print(" - " .. name .. " (ID: " .. id .. ")")
end

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