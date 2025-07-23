rednet.open("top")
local id, message = rednet.receive()
print("Received message from ID " .. id .. ": " .. message)