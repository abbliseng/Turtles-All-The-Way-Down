ae_reader = peripheral.wrap("me_bridge_1")

rednet.open("back")
rednet.send(6, "hello")