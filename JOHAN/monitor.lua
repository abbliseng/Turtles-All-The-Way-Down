local monitor = peripheral.find("monitor")
monitor.setCursorPos(1, 1)
monitor.setTextScale(1)
-- monitor.write("JOHAN Monitor Initialized")

local size = monitor.getSize()
local progress = 0
local status = "Idle"
local statusColor = colors.gray

local colors = {
    red = colors.red,
    yellow = colors.yellow,
    green = colors.lime,
    gray = colors.gray,
    white = colors.white,
    black = colors.black,
    blue = colors.blue
}

local buttons = {
    { label = "Start", x = 2,  y = 2, w = 10, h = 3, action = function() status = "Running" end },
    { label = "Stop",  x = 14, y = 2, w = 10, h = 3, action = function() status = "Stopped" end },
    { label = "Reset", x = 26, y = 2, w = 10, h = 3, action = function() progress = 0 end }
}



-- Helper: draw box with text
local function drawButton(b)
    for dy = 0, b.h - 1 do
        monitor.setCursorPos(b.x, b.y + dy)
        monitor.setBackgroundColor(colors.blue)
        monitor.setTextColor(colors.white)
        monitor.write(string.rep(" ", b.w))
    end
    monitor.setCursorPos(b.x + math.floor((b.w - #b.label) / 2), b.y + math.floor(b.h / 2))
    monitor.write(b.label)
end

-- Draw loading bar
local function drawProgressBar(x, y, w, value)
    monitor.setCursorPos(x, y)
    monitor.setBackgroundColor(colors.gray)
    monitor.write(string.rep(" ", w))
    monitor.setCursorPos(x, y)
    monitor.setBackgroundColor(colors.green)
    local filled = math.floor(value * w)
    monitor.write(string.rep(" ", filled))
end

local function drawStatusIcon(x, y, color)
    monitor.setCursorPos(x, y)
    monitor.setBackgroundColor(color)
    monitor.write(" ")
end

-- Redraw entire UI
local function drawUI()
    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    for _, b in pairs(buttons) do
        drawButton(b)
    end

    monitor.setCursorPos(2, 7)
    monitor.setTextColor(colors.white)
    monitor.write("Status: " .. status)

    -- Status color logic
    if status == "Running" then
        statusColor = colors.green
    elseif status == "Stopped" then
        statusColor = colors.red
    else
        statusColor = colors.gray
    end
    print("Status color: " .. statusColor)
    drawStatusIcon(20, 7, statusColor)

    -- Progress bar
    drawProgressBar(2, 9, 60, progress)
end


-- Handle monitor click
local function handleTouch(x, y)
    for _, b in pairs(buttons) do
        if x >= b.x and x < b.x + b.w and y >= b.y and y < b.y + b.h then
            print("Button pressed: " .. b.label)
            b.action()
            drawUI()
            return
        end
    end
end

-- Main loop
print("JOHAN Monitor started...")
print(size)
drawUI()
local timer = os.startTimer(0.1)

while true do
    local event, p1, p2, p3 = os.pullEvent()
    if event == "monitor_touch" then
        local side, x, y = p1, p2, p3
        handleTouch(x, y)
    elseif event == "timer" and p1 == timer then
        print("Timer with ID " .. p1 .. " was fired")
    
    -- Simulate progress when running
        if (status == "Running") then
            print("Updating progress...")
            progress = math.min(progress + 0.05, 1)
            drawUI()
        end
        timer = os.startTimer(0.1)
    end
end
