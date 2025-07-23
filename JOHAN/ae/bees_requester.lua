rednet.open("back")
ae_reader = peripheral.wrap("me_bridge_1")
request_timer = os.startTimer(30)

function requestItems()

    available_items = {}
    item_file = fs.open("JOHAN/ae/data/bees_available_items.txt", "r")

    local line = item_file.readAll()
    available_items = textutils.unserialize(line)

    item_file.close()

    threshold = 5000
    items_to_request = {}


    for key, item in ipairs(available_items) do
        local data = ae_reader.getItem(item)
        if (item.displayName == "[Steel Nugget]") then
            goto continue
        end
        if (data == nil) then
            print("Missing item: " .. item.displayName)
            table.insert(items_to_request, item)
        elseif data.count < threshold then
            print("Missing " .. (threshold - data.count) .. " " .. data.displayName)
            table.insert(items_to_request, item)
        end
        ::continue::
    end

    rednet.send(6, textutils.serialise(items_to_request))
end

while true do
    os.pullEvent("timer")
    requestItems()
    request_timer = os.startTimer(30)
end