rednet.open("back")
ae_reader = peripheral.wrap("me_bridge_1")

available_items = {}
item_file = fs.open("JOHAN/ae/data/bees_available_items.txt", "r")

local line = item_file.readAll()
available_items = textutils.unserialize(line)

item_file.close()

threshold = 5000

for key, item in ipairs(available_items) do
    local data = ae_reader.getItem(item)
    if (item.displayName == "[Steel Nugget]") then
        goto continue
    end
    if (data == nil) then
        print("Missing item: " .. item.displayName)
    elseif data.count < threshold then
        print("Missing " .. (threshold - data.count) .. " " .. data.displayName)
    end
    ::continue::
end