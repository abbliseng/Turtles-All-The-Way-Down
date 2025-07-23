rednet.open("back")

available_items = {}
item_file = fs.open("JOHAN/ae/data/bees_available_items.txt", "r")

while true do
    local line = item_file.readLine()
    if not line then break end
    table.insert(available_items, line)
end

item_file.close()

for key, item in ipairs(available_items) do
    print(" - " .. item)
end