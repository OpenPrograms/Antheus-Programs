local event = require("event")
local component = require("component")
local modem = component.modem
local port = 15
local computer = require("computer")
local term = require("term")
local gpu = component.gpu
local colors = require("colors")
modem.open(15)
term.clear()

local x,y = gpu.maxResolution()
local x = x/2
gpu.setResolution(x, 10)
gpu.setBackground(0xFFFFFF)
gpu.setForeground(0x32cd32)
term.clear()

while true do
    msg2 = nil
    local event, laddr, raddr, port, dist, msg1, msg2 = event.pull(10, "modem_message")
    if msg2 ~= nil then print(msg2) end
end