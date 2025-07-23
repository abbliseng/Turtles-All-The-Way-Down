rednet.open("back")
ae_reader = peripheral.wrap("me_bridge_1")

available_items = {}
item_file = fs.open("JOHAN/ae/data/bees_available_items.txt", "r")

while true do
    local line = item_file.readLine()
    line = textutils.unserialize(line)
    if not line then break end
    table.insert(available_items, line)
end

item_file.close()

for key, item in ipairs(available_items) do
    local data = ae_reader.getItem(item)
    print(" - " .. item)
    print(data)
end