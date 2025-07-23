local function getAvailableItems(ae_reader)
    local items = ae_reader.getItems()
    local available_items = {}
    for id, item in ipairs(items) do
        available_items[id] = item
    end
    return available_items
end

local function sendAvailableItemsToComputer(reciever_id, ae_reader)
    local available_items = getAvailableItems(ae_reader)
    rednet.send(reciever_id, available_items)
end

-- print("Available items:")
-- for id, name in pairs(available_items) do
--     print(" - " .. name .. " (ID: " .. id .. ")")
-- end

-- local id, message = rednet.receive()
-- print("Received message from ID " .. id .. ": " .. message)

rednet.open("top")

local get_available_items_timer = os.startTimer(30)
local ae_reader = peripheral.wrap("me_bridge_2")

while true do
    local event, param = os.pullEvent()
    if event == "timer" and param == get_available_items_timer then
        sendAvailableItemsToComputer(4, ae_reader)
        get_available_items_timer = os.startTimer(30)
    end
end