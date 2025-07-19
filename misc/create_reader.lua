local function safeSerialize(value, seen)
    seen = seen or {}

    if type(value) == "table" then
        if seen[value] then
            return "\"<circular>\""
        end
        seen[value] = true

        local result = "{"
        for k, v in pairs(value) do
            result = result .. "[" .. safeSerialize(k, seen) .. "]=" .. safeSerialize(v, seen) .. ","
        end
        result = result .. "}"
        return result
    elseif type(value) == "string" then
        return string.format("%q", value)
    else
        return tostring(value)
    end
end

local reader = peripheral.wrap("block_reader_0")
local data = reader.getBlockData()

local file = fs.open("output.txt", "w")
file.write(safeSerialize(data))
file.close()

print("Saved!")
