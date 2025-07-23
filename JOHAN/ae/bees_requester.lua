rednet.open("back")
ae_reader = peripheral.wrap("me_bridge_1")

available_items = {}
item_file = fs.open("JOHAN/ae/data/bees_available_items.txt", "r")

local line = item_file.readAll()
available_items = textutils.unserialize(line)

item_file.close()

for key, item in ipairs(available_items) do
    local data = ae_reader.getItem(item)
    print(" - " .. item)
    print(data)
end